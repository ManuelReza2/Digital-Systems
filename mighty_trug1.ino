 const int dipSwitchPin1 = 2;  // Pin para el primer interruptor DIP
const int dipSwitchPin2 = 3;  // Pin para el segundo interruptor DIP
const int dipSwitchPin3 = 4;  // Pin para el tercer interruptor DIP

const int ledPins[] = {5, 6, 7, 8, 9, 10};  // Pins de los LEDs (L1, L2, L3, R1, R2, R3)

void setup() {
  for (int i = 0; i < 6; i++) {
    pinMode(ledPins[i], OUTPUT);
  }
  
  pinMode(dipSwitchPin1, INPUT_PULLUP);
  pinMode(dipSwitchPin2, INPUT_PULLUP);
  pinMode(dipSwitchPin3, INPUT_PULLUP);
}

void loop() {
  int dipSwitchState1 = digitalRead(dipSwitchPin1);
  int dipSwitchState2 = digitalRead(dipSwitchPin2);
  int dipSwitchState3 = digitalRead(dipSwitchPin3);

  // Combinación "100" (señal de giro a la derecha)
  if (dipSwitchState1 == HIGH && dipSwitchState2 == LOW && dipSwitchState3 == LOW) {
    delay (100);
    sequenceRightTurn();
  }
  // Combinación "001" (señal de giro a la izquierda)
  else if (dipSwitchState1 == LOW && dipSwitchState2 == LOW && dipSwitchState3 == HIGH) {
    delay(100);
    sequenceLeftTurn();
  }
  // Combinación "010" (luces intermitentes)
  else if (dipSwitchState1 == LOW && dipSwitchState2 == HIGH && dipSwitchState3 == LOW) {
    sequenceFlashingLights();
  }
  // Combinación "000" (estado predeterminado)
  else {
    allLightsOff();
  }
}

void sequenceRightTurn() {
  for (int i = 5; i >= 3; i--) {
    digitalWrite(ledPins[i], HIGH);
    delay(100);
  }
  // Apagar todos los LEDs a la vez
  for (int i = 5; i >= 3; i--) {
    digitalWrite(ledPins[i], LOW);
  }
    delay(100);
}

void sequenceLeftTurn() {
  for (int i = 0; i < 3; i++) {
    digitalWrite(ledPins[i], HIGH);
    delay(100);
  }
  // Apagar todos los LEDs a la vez
  for (int i = 0; i < 3; i++) {
    digitalWrite(ledPins[i], LOW);
  }
  delay(100);
}

void sequenceFlashingLights() {
  digitalWrite(ledPins[0], HIGH);
  digitalWrite(ledPins[5], HIGH);
  delay(280);
  
  digitalWrite(ledPins[1], HIGH);
  digitalWrite(ledPins[4], HIGH);
  delay(280);
  
  digitalWrite(ledPins[2], HIGH);
  digitalWrite(ledPins[3], HIGH);
  delay(100);
  
  for (int i = 0; i < 6; i++) {
    digitalWrite(ledPins[i], LOW);
  }
  delay(300);
}
void allLightsOff() {
  for (int i = 0; i < 6; i++) {
    digitalWrite(ledPins[i], LOW);
  }
}
