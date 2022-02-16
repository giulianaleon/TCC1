#include <AudioFrequencyMeter.h>
#include <SerialCommand.h>

AudioFrequencyMeter meter;

void setup() {

  SerialUSB.begin(115200);

  meter.setBandwidth(50, 200);    // Ignore frequency out of this range
  meter.begin(A1, 5000);             // Initialize A0 at sample rate of 45 kHz
}

void loop() {
  
  float frequency = meter.getFrequency();
  if (frequency > 0)
  {
    //SerialUSB.print(frequency); //SerialUSB.println(" Hz");
    SerialUSB.write(frequency); 
    //SerialUSB.println("-");
  }
  delay(100);
}
