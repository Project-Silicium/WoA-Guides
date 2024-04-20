#!/sbin/sh
echo 0xEF > /config/usb_gadget/g1/bDeviceClass; echo 0x02 > /config/usb_gadget/g1/bDeviceSubClass; echo 0x01 > /config/usb_gadget/g1/bDeviceProtocol; echo 0x00 > /config/usb_gadget/g1/functions/mass_storage.0/lun.0/cdrom; echo 0x00 > /config/usb_gadget/g1/functions/mass_storage.0/lun.0/ro
ln -s /config/usb_gadget/g1/functions/mass_storage.0/ /config/usb_gadget/g1/configs/b.1/
echo /dev/block/sda > /config/usb_gadget/g1/configs/b.1/mass_storage.0/lun.0/file
echo 0 > /config/usb_gadget/g1/configs/b.1/mass_storage.0/lun.0/removable
sh -c 'echo > /config/usb_gadget/g1/UDC; echo a800000.dwc3 > /config/usb_gadget/g1/UDC' &
