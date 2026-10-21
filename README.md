# FPGA VGA Sprite Animatie met Arduino Joystick Besturing

Dit project demonstreert hoe sprites grafisch worden weergegeven en bewogen op een VGA-scherm, aangestuurd via een FPGA. De hardwarematige logica voor de spriteweergave is geprogrammeerd in VHDL. De realtime coördinaten worden berekend door een Arduino met een joystickmodule en via UART (seriële communicatie) naar de FPGA verzonden.

📺 **[Bekijk hier de demonstratievideo van het project](https://1drv.ms/v/c/b2abd14c679eea6b/IQDNG7WMvDCmRqGBd7nk_20RAV5LHQwgeFbFaG3wz7Co0hg?e=wmgPjz)**

---

## 🚀 Kenmerken
* **Hardware VGA Rendering:** Directe, low-level generatie en weergave van sprites op een VGA-scherm via VHDL.
* **Realtime Joystick Besturing:** Een analoge joystickmodule aangesloten op de Arduino vertaalt fysieke beweging naar nauwkeurige positiecoördinaten.
* **UART Communicatie:** Betrouwbare seriële data-overdracht vormt de brug tussen de Arduino en de FPGA.
* **Vloeiende Beweging:** Dynamische updates van de spritepositie op de schermresolutie op basis van binnenkomende data.

## 🛠️ Systeemarchitectuur

1. **Input:** De **Arduino** leest de analoge spanningswaarden van de **Joystick Module** (X- en Y-as) uit.
2. **Datatransmissie:** De Arduino zet deze waarden om in coördinaten en verzendt deze als datapakketjes via **UART** (Serial).
3. **Verwerking & Weergave:** De **FPGA** decodeert de seriële UART-data, werkt de interne positieregisters bij en stuurt het **VGA-scherm** aan via custom **VHDL**-modules om de sprite te verplaatsen.

---

## ⚙️ Vereisten & Componenten

### Hardware
* **FPGA Ontwikkelbord** (met VGA-uitgang of DAC-netwerk)
* **Arduino** (bijv. Uno, Nano of Mega)
* **Analoge Joystick Module** (Dual-axis)
* **VGA-Monitor** & VGA-kabel
* Jumperwires (verbindingskabels)

### Software / Talen
* **VHDL:** Voor de FPGA-hardware (VGA-controller, UART-ontvanger en sprite-rendering).
* **C++ (Arduino IDE):** Voor het uitlezen van de joystick en het verzenden van de seriële data.

---

## 📝 Licentie
Dit project is open-source. Voel je vrij om de code te gebruiken, aan te passen en te verspreiden voor educatieve doeleinden.
