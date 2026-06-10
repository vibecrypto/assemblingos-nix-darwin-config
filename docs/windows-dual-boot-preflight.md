# Windows And NixOS Dual-Boot Preflight

Do not begin partition changes until every item below is complete.

## Required Information

- laptop manufacturer and exact model
- CPU
- GPU or GPUs
- Wi-Fi chipset
- disk count and capacity
- UEFI or legacy boot mode
- Windows edition
- BitLocker/device-encryption status
- available unallocated disk space
- desired NixOS desktop

Record these in `docs/host-inventory.md`.

## Backups And Recovery

- Create a tested backup of important files.
- Store the BitLocker recovery key outside the laptop.
- Create Windows recovery media.
- Confirm that you can sign in to the Microsoft account holding the recovery
  key, if applicable.
- Confirm Windows boots correctly before changing partitions.

## Windows Preparation

- Install pending Windows updates.
- Disable Windows Fast Startup.
- Suspend BitLocker before boot/partition changes if required by Microsoft's
  current guidance for the machine.
- Use Windows Disk Management to shrink the Windows filesystem.
- Leave the intended NixOS space unallocated.
- Do not delete the EFI, Windows recovery, Microsoft reserved, or Windows data
  partitions.

## Recommended Risk Order

1. Test NixOS in a VM.
2. Test the NixOS live USB without installation.
3. Prefer a separate physical disk when available.
4. Use same-disk dual boot only with backups and recovery media.

## Installation

Use the current NixOS installation manual:

```text
https://nixos.org/manual/nixos/stable/#sec-installation
```

Partitioning commands vary by disk layout. This repository intentionally does
not provide a universal destructive partition script.

## Post-Install Acceptance Test

Before replacing the installer-generated NixOS configuration:

- boot Windows
- boot NixOS
- connect to Wi-Fi
- test Ethernet if available
- test keyboard and pointing devices
- test display brightness
- test audio and microphone
- test Bluetooth
- test suspend/resume
- test external display
- record any unsupported hardware
