EESchema Schematic File Version 2
LIBS:freetronics_schematic
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:ESPlant
LIBS:ESPlant-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 2 2
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L CN3063 U?
U 1 1 563C49C7
P 4600 3550
F 0 "U?" H 4250 4050 60  0000 C CNN
F 1 "CN3063" H 4350 3950 60  0000 C CNN
F 2 "" H 4350 3200 60  0000 C CNN
F 3 "" H 4350 3200 60  0000 C CNN
	1    4600 3550
	1    0    0    -1  
$EndComp
Text HLabel 1650 1450 0    60   Input ~ 0
USB_IN
Text HLabel 1700 2100 0    60   Input ~ 0
SOLAR_IN
Text HLabel 10850 3350 2    60   Input ~ 0
VLOAD
$Comp
L BATTERY BAT?
U 1 1 563C4CDD
P 6400 3700
F 0 "BAT?" H 6400 3900 50  0000 C CNN
F 1 "3.7V Lithium Battery" H 6400 3510 50  0000 C CNN
F 2 "" H 6400 3700 60  0000 C CNN
F 3 "" H 6400 3700 60  0000 C CNN
	1    6400 3700
	0    1    1    0   
$EndComp
Wire Wire Line
	5250 3350 8800 3350
Wire Wire Line
	6400 3350 6400 3400
Wire Wire Line
	5600 3350 5600 3050
Wire Wire Line
	5600 3050 5250 3050
Connection ~ 5600 3350
Wire Wire Line
	5250 3850 5750 3850
Wire Wire Line
	5750 3850 5750 4650
Wire Wire Line
	4550 4450 4550 4950
Wire Wire Line
	4550 4650 6400 4650
Connection ~ 4550 4650
$Comp
L GND #PWR?
U 1 1 563C4E24
P 4550 4950
F 0 "#PWR?" H 4550 4700 50  0001 C CNN
F 1 "GND" H 4550 4800 50  0000 C CNN
F 2 "" H 4550 4950 60  0000 C CNN
F 3 "" H 4550 4950 60  0000 C CNN
	1    4550 4950
	1    0    0    -1  
$EndComp
$Comp
L R R?
U 1 1 563C4E3C
P 5500 4350
F 0 "R?" V 5580 4350 50  0000 C CNN
F 1 "?" V 5500 4350 50  0000 C CNN
F 2 "" V 5430 4350 30  0000 C CNN
F 3 "" H 5500 4350 30  0000 C CNN
	1    5500 4350
	1    0    0    -1  
$EndComp
Wire Wire Line
	5500 4200 5500 4150
Wire Wire Line
	5500 4150 5250 4150
Wire Wire Line
	5500 4500 5500 4650
Connection ~ 5500 4650
Wire Wire Line
	4600 2100 4600 2750
$Comp
L MOSFET_P Q?
U 1 1 563C5071
P 9000 3450
F 0 "Q?" H 8910 3620 60  0000 R CNN
F 1 "MOSFET_P" H 9060 3200 60  0000 R CNN
F 2 "" H 9000 3450 60  0000 C CNN
F 3 "" H 9000 3450 60  0000 C CNN
	1    9000 3450
	0    -1   -1   0   
$EndComp
Connection ~ 4600 2100
$Comp
L MOSFET_P Q?
U 1 1 563C5347
P 2400 2000
F 0 "Q?" H 2310 2170 60  0000 R CNN
F 1 "MOSFET_P" H 2460 1750 60  0000 R CNN
F 2 "" H 2400 2000 60  0000 C CNN
F 3 "" H 2400 2000 60  0000 C CNN
	1    2400 2000
	0    -1   1    0   
$EndComp
Wire Wire Line
	1700 2100 2200 2100
Wire Wire Line
	2400 1450 2400 1800
Wire Wire Line
	1650 1450 2750 1450
$Comp
L DIODE_SCHOTTKY D?
U 1 1 563C54FD
P 2950 1450
F 0 "D?" H 2950 1550 40  0000 C CNN
F 1 "SS14" H 2950 1350 40  0000 C CNN
F 2 "" H 2950 1450 60  0000 C CNN
F 3 "" H 2950 1450 60  0000 C CNN
	1    2950 1450
	1    0    0    -1  
$EndComp
Connection ~ 2400 1450
Wire Wire Line
	3150 1450 3450 1450
Wire Wire Line
	3450 1450 3450 2100
Connection ~ 3450 2100
$Comp
L R R?
U 1 1 563C5AF3
P 2050 1650
F 0 "R?" V 2130 1650 50  0000 C CNN
F 1 "1K" V 2050 1650 50  0000 C CNN
F 2 "" H 2050 1650 60  0000 C CNN
F 3 "" H 2050 1650 60  0000 C CNN
	1    2050 1650
	0    1    1    0   
$EndComp
$Comp
L GND #PWR?
U 1 1 563C5B2C
P 1700 1800
F 0 "#PWR?" H 1700 1550 50  0001 C CNN
F 1 "GND" H 1700 1650 50  0000 C CNN
F 2 "" H 1700 1800 60  0000 C CNN
F 3 "" H 1700 1800 60  0000 C CNN
	1    1700 1800
	1    0    0    -1  
$EndComp
Wire Wire Line
	2300 1650 2400 1650
Connection ~ 2400 1650
Wire Wire Line
	1700 1650 1800 1650
Wire Wire Line
	1700 1650 1700 1800
Wire Wire Line
	2600 2100 5050 2100
Connection ~ 6400 3350
Wire Wire Line
	3500 3950 3950 3950
$Comp
L LED LED?
U 1 1 563C5FC4
P 3500 3700
F 0 "LED?" H 3500 3800 50  0000 C CNN
F 1 "LED" H 3500 3600 50  0000 C CNN
F 2 "" H 3500 3700 60  0000 C CNN
F 3 "" H 3500 3700 60  0000 C CNN
	1    3500 3700
	0    1    1    0   
$EndComp
$Comp
L R R?
U 1 1 563C6031
P 3500 3100
F 0 "R?" V 3580 3100 50  0000 C CNN
F 1 "330R" V 3500 3100 50  0000 C CNN
F 2 "" H 3500 3100 60  0000 C CNN
F 3 "" H 3500 3100 60  0000 C CNN
	1    3500 3100
	1    0    0    -1  
$EndComp
Wire Wire Line
	3500 2850 3500 2100
Connection ~ 3500 2100
Wire Wire Line
	6400 4650 6400 4000
Connection ~ 5750 4650
$Comp
L MOSFET_N Q?
U 1 1 563C671E
P 8900 4850
F 0 "Q?" H 8810 5020 60  0000 R CNN
F 1 "MOSFET_N" H 8960 4600 60  0000 R CNN
F 2 "" H 8900 4850 60  0000 C CNN
F 3 "" H 8900 4850 60  0000 C CNN
	1    8900 4850
	1    0    0    -1  
$EndComp
Text Label 3750 2100 0    60   ~ 0
VIN
Wire Wire Line
	7850 4850 8700 4850
Text Label 7850 4850 0    60   ~ 0
~CHARGER_ON
Wire Wire Line
	9000 3650 9000 4650
Wire Wire Line
	9000 5050 9000 5250
$Comp
L GND #PWR?
U 1 1 563C7001
P 9000 5250
F 0 "#PWR?" H 9000 5000 50  0001 C CNN
F 1 "GND" H 9000 5100 50  0000 C CNN
F 2 "" H 9000 5250 60  0000 C CNN
F 3 "" H 9000 5250 60  0000 C CNN
	1    9000 5250
	1    0    0    -1  
$EndComp
Wire Wire Line
	9200 3350 9900 3350
Wire Wire Line
	3500 3900 3500 4150
Connection ~ 3500 3950
Wire Wire Line
	3500 3350 3500 3500
Connection ~ 3500 4150
$Comp
L DIODE_SCHOTTKY D?
U 1 1 563FE208
P 9000 3050
F 0 "D?" H 9000 3150 40  0000 C CNN
F 1 "SS14" H 9000 2950 40  0000 C CNN
F 2 "" H 9000 3050 60  0000 C CNN
F 3 "" H 9000 3050 60  0000 C CNN
	1    9000 3050
	1    0    0    -1  
$EndComp
Wire Wire Line
	8800 3050 8600 3050
Wire Wire Line
	8600 3050 8600 3350
Connection ~ 8600 3350
Wire Wire Line
	9200 3050 9400 3050
Wire Wire Line
	9400 3050 9400 3350
Connection ~ 9400 3350
$Comp
L MOSFET_P Q?
U 1 1 563FE525
P 5250 2200
F 0 "Q?" H 5160 2370 60  0000 R CNN
F 1 "AOD4189" V 5150 2050 60  0000 R CNN
F 2 "" H 5250 2200 60  0000 C CNN
F 3 "" H 5250 2200 60  0000 C CNN
	1    5250 2200
	0    -1   -1   0   
$EndComp
$Comp
L DIODE_SCHOTTKY D?
U 1 1 563FE5E4
P 5250 1800
F 0 "D?" H 5250 1900 40  0000 C CNN
F 1 "SS14" H 5250 1700 40  0000 C CNN
F 2 "" H 5250 1800 60  0000 C CNN
F 3 "" H 5250 1800 60  0000 C CNN
	1    5250 1800
	1    0    0    -1  
$EndComp
Wire Wire Line
	5450 1800 5900 1800
Wire Wire Line
	5900 1800 5900 2100
Wire Wire Line
	5450 2100 9700 2100
Wire Wire Line
	9700 2100 9700 3350
Connection ~ 9700 3350
Connection ~ 5900 2100
Wire Wire Line
	5050 1800 4850 1800
Wire Wire Line
	4850 1800 4850 2100
Connection ~ 4850 2100
Wire Wire Line
	5250 2400 5250 2600
Wire Wire Line
	5250 2600 4900 2600
$Comp
L R R?
U 1 1 563FE923
P 9550 4100
F 0 "R?" V 9630 4100 50  0000 C CNN
F 1 "100K" V 9550 4100 50  0000 C CNN
F 2 "" H 9550 4100 60  0000 C CNN
F 3 "" H 9550 4100 60  0000 C CNN
	1    9550 4100
	1    0    0    -1  
$EndComp
Connection ~ 9000 4450
Wire Wire Line
	9000 4450 9550 4450
Wire Wire Line
	9550 4450 9550 4350
Wire Wire Line
	9550 3850 9550 3350
Connection ~ 9550 3350
$Comp
L R R?
U 1 1 563FEFDB
P 8450 4150
F 0 "R?" V 8530 4150 50  0000 C CNN
F 1 "100K" V 8450 4150 50  0000 C CNN
F 2 "" H 8450 4150 60  0000 C CNN
F 3 "" H 8450 4150 60  0000 C CNN
	1    8450 4150
	1    0    0    -1  
$EndComp
Wire Wire Line
	8450 3900 8450 3750
Wire Wire Line
	8450 4400 8450 4850
Wire Wire Line
	3000 4150 3950 4150
$Comp
L LED LED?
U 1 1 563FF8B1
P 3000 3700
F 0 "LED?" H 3000 3800 50  0000 C CNN
F 1 "LED" H 3000 3600 50  0000 C CNN
F 2 "" H 3000 3700 60  0000 C CNN
F 3 "" H 3000 3700 60  0000 C CNN
	1    3000 3700
	0    1    1    0   
$EndComp
$Comp
L R R?
U 1 1 563FF8B7
P 3000 3100
F 0 "R?" V 3080 3100 50  0000 C CNN
F 1 "330R" V 3000 3100 50  0000 C CNN
F 2 "" H 3000 3100 60  0000 C CNN
F 3 "" H 3000 3100 60  0000 C CNN
	1    3000 3100
	1    0    0    -1  
$EndComp
Wire Wire Line
	3000 3350 3000 3500
Wire Wire Line
	3000 2850 3000 2100
Connection ~ 3000 2100
Wire Wire Line
	3000 3900 3000 4150
Text Label 3650 3950 0    60   ~ 0
~CHRG
Text Label 3650 4150 0    60   ~ 0
~DONE
$Comp
L DIODE_SCHOTTKY D?
U 1 1 563FFF18
P 7600 4650
F 0 "D?" H 7600 4750 40  0000 C CNN
F 1 "SS14" H 7600 4550 40  0000 C CNN
F 2 "" H 7600 4650 60  0000 C CNN
F 3 "" H 7600 4650 60  0000 C CNN
	1    7600 4650
	-1   0    0    1   
$EndComp
$Comp
L DIODE_SCHOTTKY D?
U 1 1 563FFFB2
P 7600 5150
F 0 "D?" H 7600 5250 40  0000 C CNN
F 1 "SS14" H 7600 5050 40  0000 C CNN
F 2 "" H 7600 5150 60  0000 C CNN
F 3 "" H 7600 5150 60  0000 C CNN
	1    7600 5150
	-1   0    0    1   
$EndComp
Wire Wire Line
	7400 4650 7000 4650
Wire Wire Line
	7400 5150 7000 5150
Wire Wire Line
	7800 4650 7850 4650
Wire Wire Line
	7850 4650 7850 5150
Wire Wire Line
	7850 5150 7800 5150
Connection ~ 7850 4850
Text Label 7000 4650 0    60   ~ 0
~CHRG
Text Label 7000 5150 0    60   ~ 0
~DONE
Text Notes 7800 5750 0    60   ~ 0
~CHARGER_ON\nLOW = <1V\nHIGH = VOUT\n\n2N7002 gate\nthreshold = 1V - 2.5V
Connection ~ 8450 4850
Wire Wire Line
	8450 3750 7500 3750
$Comp
L INDUCTOR_SMALL L?
U 1 1 56401858
P 10150 3350
F 0 "L?" H 10150 3450 50  0000 C CNN
F 1 "?uH" H 10150 3300 50  0000 C CNN
F 2 "" H 10150 3350 60  0000 C CNN
F 3 "" H 10150 3350 60  0000 C CNN
	1    10150 3350
	1    0    0    -1  
$EndComp
$Comp
L CP C?
U 1 1 56401916
P 10700 3600
F 0 "C?" H 10725 3700 50  0000 L CNN
F 1 "470uF 16V" H 10725 3500 50  0000 L CNN
F 2 "" H 10738 3450 30  0000 C CNN
F 3 "" H 10700 3600 60  0000 C CNN
	1    10700 3600
	1    0    0    -1  
$EndComp
$Comp
L C C?
U 1 1 5640199A
P 10450 3600
F 0 "C?" H 10475 3700 50  0000 L CNN
F 1 "47uF 16V" H 10200 3500 50  0000 L CNN
F 2 "" H 10488 3450 30  0000 C CNN
F 3 "" H 10450 3600 60  0000 C CNN
	1    10450 3600
	1    0    0    -1  
$EndComp
Wire Wire Line
	10400 3350 10850 3350
Wire Wire Line
	10700 3450 10700 3350
Connection ~ 10700 3350
Wire Wire Line
	10450 3450 10450 3350
Connection ~ 10450 3350
Wire Wire Line
	10450 3750 10450 4450
$Comp
L GND #PWR?
U 1 1 56401BE8
P 10450 4450
F 0 "#PWR?" H 10450 4200 50  0001 C CNN
F 1 "GND" H 10450 4300 50  0000 C CNN
F 2 "" H 10450 4450 60  0000 C CNN
F 3 "" H 10450 4450 60  0000 C CNN
	1    10450 4450
	1    0    0    -1  
$EndComp
Wire Wire Line
	10700 3750 10700 3900
Wire Wire Line
	10700 3900 10450 3900
Connection ~ 10450 3900
Text Label 4900 2600 0    60   ~ 0
~CHARGER_ON
Text Label 9400 3350 0    60   ~ 0
VOUT
Text Label 7500 3750 0    60   ~ 0
VOUT
Text Notes 5550 2600 0    60   ~ 0
AOD41897 gate\nthreshold = -1.7V - -3V
$Comp
L C C?
U 1 1 5640379D
P 9900 4700
F 0 "C?" H 9925 4800 50  0000 L CNN
F 1 "C" H 9925 4600 50  0000 L CNN
F 2 "" H 9938 4550 30  0000 C CNN
F 3 "" H 9900 4700 60  0000 C CNN
	1    9900 4700
	1    0    0    -1  
$EndComp
Wire Wire Line
	9350 4700 9350 4450
Connection ~ 9350 4450
Wire Wire Line
	9350 5000 9350 5200
Wire Wire Line
	9350 5200 9000 5200
Connection ~ 9000 5200
Text Notes 9500 5150 0    39   ~ 0
Extra capacitance here\nensures VBAT P-FET switches\noff instantly, but slow to switch\non (allows VIN to switch off first)\n\nValue TBD
$EndSCHEMATC