package com.mycompany.test;

public class Bus extends Vehicle {

 	public Bus(String licensePlate) {
   		super(licensePlate);
    	this.vehicleType = Vehicle.BUS;
    	this.numSpots = 5;
  	}

  	@Override
  	public boolean park(ParkingGarage garage) {
  		if (parkingSpot != null) leave(garage);

		if (garage.numAvailableSpots(this) < numSpots) return false;

		ParkingSpot spot = garage.findAvailableSpot(this);
		if (spot == null) return false;

		Level level = parkingSpot.getLevel();
		int row = parkingSpot.getRow();
		int index = parkingSpot.getIndex();

		level.parkVehicle(this, row, index);
		return true;
  	}
}
