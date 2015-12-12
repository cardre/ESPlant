/**
  ******************************************************************************
  * @file           : usbd_cdc_if.c
  * @brief          :
  ******************************************************************************
  * COPYRIGHT(c) 2015 STMicroelectronics
  *
  * Redistribution and use in source and binary forms, with or without modification,
  * are permitted provided that the following conditions are met:
  * 1. Redistributions of source code must retain the above copyright notice,
  * this list of conditions and the following disclaimer.
  * 2. Redistributions in binary form must reproduce the above copyright notice,
  * this list of conditions and the following disclaimer in the documentation
  * and/or other materials provided with the distribution.
  * 3. Neither the name of STMicroelectronics nor the names of its contributors
  * may be used to endorse or promote products derived from this software
  * without specific prior written permission.
  *
  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
  * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
  * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
  * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
  * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
  * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  ******************************************************************************
*/

/* Includes ------------------------------------------------------------------*/
#include "usbd_cdc_if.h"
#include "stm32f0xx_hal_tim.h"
#include "stm32f0xx_hal_cortex.h"
#include <stdbool.h>

/* USER CODE BEGIN INCLUDE */
/* USER CODE END INCLUDE */

/** @addtogroup STM32_USB_OTG_DEVICE_LIBRARY
  * @{
  */

/** @defgroup USBD_CDC
  * @brief usbd core module
  * @{
  */

/** @defgroup USBD_CDC_Private_TypesDefinitions
  * @{
  */
/* USER CODE BEGIN PRIVATE TYPES  */
/* USER CODE END PRIVATE TYPES */
/**
  * @}
  */

/** @defgroup USBD_CDC_Private_Defines
  * @{
  */
/* USER CODE BEGIN PRIVATE DEFINES  */
/* Define size for the receive and transmit buffer over CDC */
/* It's up to user to redefine and/or remove those define */
/* USER CODE END PRIVATE DEFINES */
/**
  * @}
  */

/** @defgroup USBD_CDC_Private_Macros
  * @{
  */
/* USER CODE BEGIN PRIVATE_MACRO  */
/* USER CODE END PRIVATE_MACRO */

/**
  * @}
  */

/** @defgroup USBD_CDC_Private_Variables
  * @{
  */

/* Receive data over USB CDC buffer into these two
   buffers, page flip between them (so one is outputting
   USART while other is receiving from CDC)*/
#define cdc2usart_SIZE CDC_DATA_FS_MAX_PACKET_SIZE
uint8_t cdc2usart_buf_a[cdc2usart_SIZE];
uint8_t cdc2usart_buf_b[cdc2usart_SIZE];

/* Send Data over USB CDC are stored in this ringbuffer       */
#define usart2cdc_SIZE 64
uint8_t usart2cdc_buf[usart2cdc_SIZE];
uint8_t *usart2cdc_rx = usart2cdc_buf; /* Next RX from UART */
uint8_t *usart2cdc_tx = usart2cdc_buf; /* Next TX to CDC */

/* BEWARE: Horrible macro hackery */

/* Return space free to RX into buffer */
#define RBUF_FREE(BUF) (BUF##_tx > BUF##_rx ? BUF##_tx-BUF##_rx \
			: BUF##_tx+BUF##_SIZE-BUF##_rx)

/* USB handler declaration */
/* Handle for USB Full Speed IP */
USBD_HandleTypeDef  *husb;

/* handle for the USART */
UART_HandleTypeDef huart2;

TIM_HandleTypeDef htimer;

/* USER CODE BEGIN PRIVATE_VARIABLES  */
/* USER CODE END  PRIVATE VARIABLES */

/**
  * @}
  */

/** @defgroup USBD_CDC_IF_Exported_Variables
  * @{
  */
  extern USBD_HandleTypeDef hUsbDeviceFS;
/* USER CODE BEGIN EXPORTED_VARIABLES  */
/* USER CODE END  EXPORTED_VARIABLES */

/**
  * @}
  */

/** @defgroup USBD_CDC_Private_FunctionPrototypes
  * @{
  */
static int8_t CDC_Init_FS     (void);
static int8_t CDC_DeInit_FS   (void);
static int8_t CDC_Control_FS  (uint8_t cmd, uint8_t* pbuf, uint16_t length);
static int8_t CDC_Receive_FS  (uint8_t* pbuf, uint32_t *Len);

static uint8_t CDC_Transmit_FS(void);

/* USER CODE BEGIN PRIVATE_FUNCTIONS_DECLARATION */
/* USER CODE END  PRIVATE_FUNCTIONS_DECLARATION */

/**
  * @}
  */

USBD_CDC_ItfTypeDef USBD_Interface_fops_FS =
{
  CDC_Init_FS,
  CDC_DeInit_FS,
  CDC_Control_FS,
  CDC_Receive_FS
};

/* Private functions ---------------------------------------------------------*/
/**
  * @brief  CDC_Init_FS
  *         Initializes the CDC media low layer over the FS USB IP
  * @param  None
  * @retval Result of the operation: USBD_OK if all operations are OK else USBD_FAIL
  */
static int8_t CDC_Init_FS(void)
{
  husb = &hUsbDeviceFS;

  /* Configure the USART with some sensible defaults

     TODO: If possible, don't drive TX high while CDC is "closed"?
   */
  huart2.Instance = USART2;
  huart2.Init.BaudRate = 115200;
  huart2.Init.WordLength = UART_WORDLENGTH_8B;
  huart2.Init.StopBits = UART_STOPBITS_1;
  huart2.Init.Parity = UART_PARITY_NONE;
  huart2.Init.Mode = UART_MODE_TX_RX;
  huart2.Init.HwFlowCtl = UART_HWCONTROL_NONE;
  huart2.Init.OverSampling = UART_OVERSAMPLING_16;
  huart2.Init.OneBitSampling = UART_ONEBIT_SAMPLING_DISABLED ;
  huart2.AdvancedInit.AdvFeatureInit = UART_ADVFEATURE_NO_INIT;
  HAL_UART_Init(&huart2);

  /* Enable USART2 in NVIC, set priority to high */
  NVIC_SetPriority(USART2_IRQn, 1);
  NVIC_EnableIRQ(USART2_IRQn);

  /* UART2 receives data to the CDC transmit buffer, byte at a time :( */
  if(HAL_UART_Receive_IT(&huart2, usart2cdc_rx, 1) != HAL_OK)
    return USBD_FAIL;

  /* Configure USB transmit timer */
  htimer.Instance = TIM3;
  htimer.Init.Period = 10000 - 1; /* approx 10ms, I think... */
  htimer.Init.Prescaler = 48-1;
  htimer.Init.ClockDivision = 0;
  htimer.Init.CounterMode = TIM_COUNTERMODE_UP;
  if(HAL_TIM_Base_Init(&htimer) != HAL_OK)
    return USBD_FAIL;

  __TIM3_CLK_ENABLE();
  NVIC_SetPriority(TIM3_IRQn, 3);
  NVIC_EnableIRQ(TIM3_IRQn);

  /* Set Application USB Buffers */
  USBD_CDC_SetTxBuffer(husb, usart2cdc_tx, 0); /* don't send anything now */
  USBD_CDC_SetRxBuffer(husb, cdc2usart_buf_a);     /* read into here if CDC data comes */

  return USBD_OK;
}

void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart)
{
  usart2cdc_rx++;
  if(usart2cdc_rx == usart2cdc_buf + usart2cdc_SIZE) {
    usart2cdc_rx = usart2cdc_buf;
  }
  if(RBUF_FREE(usart2cdc) < 8) {
    /* usart2cdc buffer nearly full, try to TX CDC immediately
    */
    if(CDC_Transmit_FS() != USBD_OK && RBUF_FREE(usart2cdc) <= 1) {
      /* worst case: can't TX, and buffer already full. dropping a byte. */
      usart2cdc_tx++;
      if(usart2cdc_tx == usart2cdc_buf + usart2cdc_SIZE) {
	usart2cdc_tx = usart2cdc_buf;
      }
    }
  }

  /* Queue next byte from USART */
  HAL_UART_Receive_IT(&huart2, usart2cdc_rx, 1);

  /* Ensure the USB TX timer is running (should be idempotent) */
  HAL_TIM_Base_Start_IT(&htimer);
}

void HAL_UART_ErrorCallback(UART_HandleTypeDef *huart)
{
  /* Ignore all errors for now(!), just fire off a new receive request */
  HAL_UART_Receive_IT(&huart2, usart2cdc_rx, 1);
}

void usb_transmit_timer_elapsed_callback(void)
{
  /* try to USB transmit, if we succeed & buffer empty then we can stop TX timer until next time */
  if(CDC_Transmit_FS() == USBD_OK && usart2cdc_rx == usart2cdc_tx)
    HAL_TIM_Base_Stop_IT(&htimer);
}

/**
  * @brief  CDC_DeInit_FS
  *         DeInitializes the CDC media low layer
  * @param  None
  * @retval Result of the operation: USBD_OK if all operations are OK else USBD_FAIL
  */
static int8_t CDC_DeInit_FS(void)
{
  /* De-assert ESP RST & GPIOA if they were being held down when USB went away */
  HAL_GPIO_WritePin(GPIOA, GPIO_PIN_7, GPIO_PIN_SET);
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_8, GPIO_PIN_SET);
  return USBD_OK;
}

/**
  * @brief  CDC_Control_FS
  *         Manage the CDC class requests
  * @param  cmd: Command code
  * @param  pbuf: Buffer containing command data (request parameters)
  * @param  length: Number of data to be sent (in bytes)
  * @retval Result of the operation: USBD_OK if all operations are OK else USBD_FAIL
  */
static int8_t CDC_Control_FS  (uint8_t cmd, uint8_t* pbuf, uint16_t length)
{
  uint32_t *pbuf_linecoding_baudrate = (uint32_t *)pbuf;
  GPIO_PinState esprst_set, gpio0_set;
  bool dtr, rts;

  /* USER CODE BEGIN 5 */
  switch (cmd)
  {
  case CDC_SEND_ENCAPSULATED_COMMAND:

    break;

  case CDC_GET_ENCAPSULATED_RESPONSE:

    break;

  case CDC_SET_COMM_FEATURE:

    break;

  case CDC_GET_COMM_FEATURE:

    break;

  case CDC_CLEAR_COMM_FEATURE:

    break;

  /*******************************************************************************/
  /* Line Coding Structure                                                       */
  /*-----------------------------------------------------------------------------*/
  /* Offset | Field       | Size | Value  | Description                          */
  /* 0      | dwDTERate   |   4  | Number |Data terminal rate, in bits per second*/
  /* 4      | bCharFormat |   1  | Number | Stop bits                            */
  /*                                        0 - 1 Stop bit                       */
  /*                                        1 - 1.5 Stop bits                    */
  /*                                        2 - 2 Stop bits                      */
  /* 5      | bParityType |  1   | Number | Parity                               */
  /*                                        0 - None                             */
  /*                                        1 - Odd                              */
  /*                                        2 - Even                             */
  /*                                        3 - Mark                             */
  /*                                        4 - Space                            */
  /* 6      | bDataBits  |   1   | Number Data bits (5, 6, 7, 8 or 16).          */
  /*******************************************************************************/
  case CDC_SET_LINE_CODING:
    /* Take baud rate setting.

       Basically ignore parity, char format, parity type, data bits -
       we don't care for this application! */
    huart2.Init.BaudRate = *pbuf_linecoding_baudrate;
    UART_SetConfig(&huart2);
    break;

  case CDC_GET_LINE_CODING:
    /* Similarly, hard code our response except for baud rate */
    *pbuf_linecoding_baudrate = huart2.Init.BaudRate;
    pbuf[4] = 0;
    pbuf[5] = 0;
    pbuf[6] = 8;
    break;

  case CDC_SET_CONTROL_LINE_STATE:
    /* DTR & RTS are treated the same as on NodeMCU boards - 
       ie both or neither assert -> normal behaviour
       either asserted -> assert GPIO0 or nRESET as appropriate
    */
    dtr = pbuf[2] & 1; // nRESET, set = hold in reset
    rts = pbuf[2] & 2; // GPIO0, set = assert to flash
    esprst_set = (!dtr && rts) ? GPIO_PIN_RESET : GPIO_PIN_SET;
    HAL_GPIO_WritePin(GPIOA, GPIO_PIN_7, esprst_set);

    gpio0_set = (dtr && !rts) ? GPIO_PIN_RESET : GPIO_PIN_SET;
    HAL_GPIO_WritePin(GPIOB, GPIO_PIN_8, gpio0_set);
    break;

  case CDC_SEND_BREAK:

    break;

  default:
    break;
  }

  return (USBD_OK);
  /* USER CODE END 5 */
}

/**
  * @brief  CDC_Receive_FS
  *         Callback. Data received over USB OUT endpoint are sent over CDC interface
  *         through this function.
  *
  *         @note
  *         This function will block any OUT packet reception on USB endpoint
  *         untill exiting this function. If you exit this function before transfer
  *         is complete on CDC interface (ie. using DMA controller) it will result
  *         in receiving more data while previous ones are still not sent.
  *
  * @param  Buf: Buffer of data to be received
  * @param  Len: Number of data received (in bytes)
  * @retval Result of the operation: USBD_OK if all operations are OK else USBD_FAIL
  */
static int8_t CDC_Receive_FS (uint8_t* buf, uint32_t *len)
{
  if(len == 0)
    return USBD_OK; /* not sure if this ever happens but it might */

  /* Push the buffer we just received into the HAL UART TX quee */
  HAL_StatusTypeDef r;
  while((r = HAL_UART_Transmit_IT(&huart2, buf, *len)) == HAL_BUSY) {
    // We could go into STOP mode here, but USB is connected so who cares about power?
    // UART, transmit timer are both higher priority interrupts so will interrupt us here
  }

  /* Swap the buffer that we'll receive next CDC packet into */
  if(buf == cdc2usart_buf_a)
    USBD_CDC_SetRxBuffer(husb, cdc2usart_buf_b);
  else
    USBD_CDC_SetRxBuffer(husb, cdc2usart_buf_a);

  USBD_CDC_ReceivePacket(husb);
  return r == HAL_OK ? USBD_OK : USBD_FAIL;
}

/**
  * @brief  CDC_Transmit_FS

  *         Not a callback. Call this function to try and transmit
  *         largest contiguous chunk of usart2cdc buffer via USB.
  *
  * @param  Buf: Buffer of data to be send
  * @param  Len: Number of data to be send (in bytes)
  * @retval Result of the operation: USBD_OK if all operations are OK else USBD_FAIL or USBD_BUSY
  */
static uint8_t CDC_Transmit_FS()
{
  uint8_t result = USBD_OK;

  if(usart2cdc_rx == usart2cdc_tx) /* nothing to do */
    return USBD_OK;

  int tx_len = usart2cdc_rx - usart2cdc_tx;
  if(tx_len < 0) { /* RX pointer has wrapped, so just TX to end of buffer */
    tx_len = usart2cdc_buf + usart2cdc_SIZE - usart2cdc_tx;
  }

  USBD_CDC_SetTxBuffer(husb, usart2cdc_tx, tx_len);
  result = USBD_CDC_TransmitPacket(husb);

  if(result == USBD_OK) { /* advance the TX pointer only if we managed to send something */
    usart2cdc_tx += tx_len;
    if(usart2cdc_tx >= usart2cdc_buf + usart2cdc_SIZE)
      usart2cdc_tx -= usart2cdc_SIZE;
  }
  return result;
}

/* USER CODE BEGIN PRIVATE_FUNCTIONS_IMPLEMENTATION */
/* USER CODE END  PRIVATE_FUNCTIONS_IMPLEMENTATION */

/**
  * @}
  */

/**
  * @}
  */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
