# Private Computing Session Guide

## 1. Run Arch Linux from a Bootable USB
- Use a live USB to avoid leaving traces on local storage.
- Consider **Tails OS** for a privacy-focused, amnesic environment.
- Disable swap to prevent data persistence.

## 2. Use a VPN Before Tor
- Connect to a **trusted VPN** before opening Tor to hide Tor usage from your ISP.
- Alternatively, use **Tor over VPN** for extra anonymity.

## 3. Secure Boot and System Configuration
- Use an **encrypted bootloader** (GRUB with LUKS for persistence if needed).
- Disable **Wi-Fi & Bluetooth** when not in use.
- Use **RAM-only OS modes** to avoid writing data to disk.

## 4. Secure Browsing
- Use **Tor Browser** with **NoScript & UBlock Origin**.
- Never log into **personal accounts** (email, social media, etc.).
- Avoid downloading files unless verified to be safe.

## 5. Additional Measures
- Use **temporary or burner email accounts**.
- Enable **DNS over HTTPS (DoH)** for additional security.
- Regularly **clear RAM & restart the session** to wipe traces.

## 6. Hardware Considerations
- If extreme privacy is needed, use a **dedicated machine**.
- Remove or disable **cameras, microphones, and other peripherals**.
- Consider **air-gapped systems**.
---


# OS Considerations

## 7. Tails OS vs. Qubes OS
- **Tails OS** runs entirely in **RAM**, leaving no trace after shutdown.
- **Qubes OS** uses **virtual machines (qubes)** to isolate different tasks.
- **Tails** is best for anonymity & Tor use, while **Qubes** is ideal for security compartmentalization. 