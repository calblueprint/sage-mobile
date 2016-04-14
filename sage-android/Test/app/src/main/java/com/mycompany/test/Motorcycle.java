package com.mycompany.test;

public class Motorcycle extends Vehicle {

 	public Motorcycle(String licensePlate) {
   		super(licensePlate);
   		this.vehicleType = Vehicle.MOTORCYCLE;
    	this.numSpots = 1;
  	}

  	// @Override
  	// public boolean canPark(ParkingGarage garage) {
  	// 	return garage.numAvailableSpots(this) > 0;
  	// }
}
