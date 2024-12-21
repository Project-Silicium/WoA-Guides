# Mu-Device-Binary
This part of UEFI-Guides is intended for those who want to know which binary device drivers (drivers from XBL) are responsible for what, which protocols they implement and how to use them.

### AdcDxe:
- Info: Soon...
- Protocol: Soon...

### ASN1X509Dxe:
- Info: Soon...
- Protocol: gEfiAdcProtocolGuid

### AW8624Dxe:
- Info: Soon...
- Protocol: Soon...

### ButtonDxe:
- Info: This driver is used by UEFI to access hardware buttons. 
- Protocol: gEfiSimpleTextInputExProtocolGuid.

### ChargerExDxe:
- Info: This driver is used by UEFI to Manage a part Charging.
- Protocol: gChargerExProtocolGuid

### ChipInfoDxe:
- Info: This driver is used by UEFI to access information about the chip. 
- Protocol: gEfiChipInfoProtocolGuid.

### CipherDxe / UCDxe:
- Info: Soon...
- Protocol: gEfiCipherProtocolGuid

### ClockDxe:
- Info: This driver is used by UEFI to control the frequency of various components. 
  For example: processor cores, display controllers and other components. 
- Protocol: gEfiClockProtocolGuid, gEfiClockRTProtocolGuid.

### CmdDbDxe:
- Info: Soon...
- Protocol: gEfiCmdDbProtocolGuid

### CPRDxe:
- Info: Soon...
- Protocol: Soon...

### DALSYSDxe:
- Info: This driver is used by UEFI to create an abstraction over the DalLib library.
  This library is used to manage the Device Abstraction Layer.
- Protocol: gEfiDalSysProtocolGuid, gEfiDalGlbCtxtProtocolGuid

### DDRInfoDxe:
- Info: Soon...
- Protocol: gEfiDDRGetInfoProtocolGuid

### DisplayDxe:
- Info: This driver is used by UEFI to control internal and external displays.
- Protocol: Soon...

### EmbeddedMonotonicCounter:
- Info: Soon...
- Protocol: Soon...

### EnvDxe:
- Info: Soon...
- Protocol: Soon...

### FeatureEnablerDxe:
- Info: Soon...
- Protocol: Soon...

### FontDxe:
- Info: Soon...
- Protocol: gEfiGraphicsOutputProtocolGuid

### FvUtilsDxe:
- Info: Soon...
- Protocol: Soon...

### GLinkDxe:
- Info: Soon...
- Protocol: gEfiGLINKProtocolGuid

### GpiDxe:
- Info: This driver is used by UEFI to provide direct memory access to various peripherals, bypassing the CPU.
- Protocol: Soon...

### HALIOMMUDxe:
- Info: Soon...
- Protocol: gEfiHalIommuProtocolGuid

### HashDxe:
- Info: Soon...
- Protocol: Soon...

### HWIODxe:
- Info: Soon...
- Protocol: Soon...

### I2CDxe:
- Info: This driver is used by UEFI to control the I2C interface.
  This interface is used to receive data, for example, from a touch screen.
- Protocol: gQcomI2CProtocolGuid

### ICBDxe:
- Info: Soon...
- Protocol: Soon...

### IPCCDxe:
- Info: Soon...
- Protocol: Soon...

### LimitsDxe:
- Info: Soon...
- Protocol: gEfiLimitsProtocolGuid

### MacDxe:
- Info: Soon...
- Protocol: Soon...

### MinidumpTADxe
- Info: Soon...
- Protocol: gQcomQseecomProtocolGuid

### NpaDxe:
- Info: This driver is used by UEFI to create, remove, and manage Node Power Architecture nodes.
- Protocol: Soon...

### ParserDxe:
- Info: Soon...
- Protocol: Soon...

### PdcDxe:
- Info: Soon...
- Protocol: Soon...

### PILDxe:
- Info: Soon...
- Protocol: gEfiPilProtocolGuid

### PILProxyDxe:
- Info: Soon...
- Protocol: Soon...

### PlatformInfoDxe:
- Info: This driver is used by UEFI to get platform information.
- Protocol: gEfiPlatformInfoProtocolGuid

### PmicDxe:
- Info: This driver is used by UEFI to manage PMIC (Power management integrated circuit).
- Protocol: Soon...

### PmicGlinkDxe:
- Info: Soon...
- Protocol: gpmicGlinkProtocolGuid

### ProjectInfoDxe:
- Info: Soon...
- Protocol: Soon...

### PwrUtilsDxe
- Info: Soon...
- Protocol: Soon...

### QcomBds:
- Info: Soon...
- Protocol: gEfiBdsArchProtocolGuid

### QcomChargerDxe:
- Info: Soon...
- Protocol: gQcomChargerProtocolGuid

### QcomMpmTimerDxe:
- Info: Soon...
- Protocol: Soon...

### QcomWDogDxe:
- Info: Soon...
- Protocol: gEfiQcomWDogProtocolGuid

### ResetRuntimeDxe:
- Info: Soon...
- Protocol: gEfiResetArchProtocolGuid, gEfiResetReasonProtocolGuid

### RpmhDxe:
- Info: Soon...
- Protocol: gEfiRpmhProtocolGuid

### RNGDxe:
- Info: Soon...
- Protocol: gEfiRNGAlgRawGuid

### ScmDxe:
- Info: Soon...
- Protocol: Soon...

### SdccDxe:
- Info: This driver is used by UEFI to access the internal eMMC storage.
- Protocol: Soon...

### SecRSADxe:
- Info: Soon...
- Protocol: Soon...

### SerialPortDxe:
- Info: Soon...
- Protocol: Soon...

### ShmBridgeDxe:
- Info: Soon...
- Protocol: gEfiShmBridgeProtocolGuid

### SimpleTextInOutSerialDxe:
- Info: Soon...
- Protocol: gEfiSimpleTextInProtocolGuid, gEfiSimpleTextOutProtocolGuid, gEfiSimpleTextInputExProtocolGuid

### SmemDxe:
- Info: Soon...
- Protocol: gEfiSMEMProtocolGuid

### SPIDxe:
- Info: This driver is used by UEFI to control the SPI interface.
  This interface is used to receive data, for example, from a touch screen.
- Protocol: gQcomSPIProtocolGuid

### SPMIDxe:
- Info: Soon...
- Protocol: gQcomSPMIProtocolGuid

### SPSSDxe:
- Info: Soon...
- Protocol: Soon...

### TLMMDxe:
- Info: This driver is used by UEFI to Manage GPIOs.
- Protocol: gEfiTLMMProtocolGuid

### TsensDxe:
- Info: This driver is used by UEFI to receive data from temperature sensors.
- Protocol: gEfiTsensProtocolGuid

### TzDxe:
- Info: Soon...
- Protocol: Soon...

### UFSDxe:
- Info: This driver is used by UEFI to access the internal UFS storage.
- Protocol: Soon...

### ULogDxe:
- Info: This driver is used by UEFI for logging to LogFS.
- Protocol: gEfiULogProtocolGuid

### UsbConfigDxe:
- Info: This driver is used by UEFI to setup a part of USB.
- Protocol: gQcomUsbConfigProtocolGuid

### UsbDeviceDxe:
- Info: Soon...
- Protocol: gEfiUsbDeviceProtocolGuid

### UsbInitDxe:
- Info: Soon...
- Protocol: gEfiUsbInitProtocolGuid

### UsbfnDwc3Dxe:
- Info: Soon...
- Protocol: gEfiUsbfnIoProtocolGuid

### UsbMsdDxe:
- Info: Soon...
- Protocol: gEfiUsbMsdPeripheralProtocolGuid

### UsbPwrCtrlDxe:
- Info: Soon...
- Protocol: gQcomUsbPwrCtrlProtocolGuid

### VariableDxe:
- Info: Soon...
- Protocol: gEfiVariableServicesProtocolGuid

### VerifiedBootDxe:
- Info: Soon...
- Protocol: gEfiQcomVerifiedBootProtocolGuid

### VcsDxe:
- Info: Soon...
- Protocol: Soon...

### VibratorDxe:
- Info: Soon...
- Protocol: Soon...

### XhciPciEmulationDxe:
- Info: Soon...
- Protocol: Soon...
