package com.mycompany.test;

public class Car extends Vehicle {

	public Car(String licensePlate) {
		super(licensePlate);
		this.vehicleType = Vehicle.CAR;
		this.numSpots = 1;
	}

	// @Override
	// public boolean canPark(ParkingGarage garage) {
	// 	return garage.numAvailableSpots(this) > 0;
	// }
}
