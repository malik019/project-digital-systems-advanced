// Pins for the Joystick
const int PIN_X = A0;
const int PIN_Y = A1;

// Grid limits for 4-bit coordinates (0 to 15)
int posX = 8; // Start in the middle
int posY = 8;

unsigned long lastSendTime = 0;

void setup() {
  Serial.begin(9600); // 9600 baud rate
}

void loop() {
  int rawX = analogRead(PIN_X);
  int rawY = analogRead(PIN_Y);

  // Smooth position tracking based on joystick input
  if (rawX < 480 && posX > 0) posX--;
  if (rawX > 540 && posX < 15) posX++;
  if (rawY < 480 && posY > 0) posY--;
  if (rawY > 540 && posY < 15) posY++;

  // Pack X and Y into a single byte: XXXX YYYY
  // Shift X left by 4 bits, then combine with Y using bitwise OR
  byte packet = (posX << 4) | (posY & 0x0F);

  // Send the single byte over UART
  Serial.write(packet);

  delay(50); // Small delay for smooth and controllable movement
}
