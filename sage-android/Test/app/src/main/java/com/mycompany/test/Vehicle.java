package com.mycompany.test;

public abstract class Vehicle {

	protected String vehicleType;
	protected int numSpots;
	protected String licensePlate;
	protected ParkingSpot parkingSpot;

	public static final String MOTORCYCLE = "Motorcycle";
	public static final String CAR = "Car";
	public static final String BUS = "Bus";

	public Vehicle(String licensePlate) {
		this.licensePlate = licensePlate;
	}

	public String getVehicleType() {
		return vehicleType;
	}

	public int getNumSpots() {
		return numSpots;
	}

	public String getLicensePlate() {
		return licensePlate;
	}

	// public abstract boolean canPark(ParkingGarage garage);

	public boolean park(ParkingGarage garage) {
		if (parkingSpot != null) {
			leave(garage);
		}

		if (garage.numAvailableSpots(this) == 0) {
			return false;
		}

		parkingSpot = garage.findAvailableSpot(this);
		if (parkingSpot == null) return false;

		Level level = parkingSpot.getLevel();
		int row = parkingSpot.getRow();
		int index = parkingSpot.getIndex();

		level.parkVehicle(this, row, index);
		return true;
	}

	public void leave(ParkingGarage garage) {
		if (parkingSpot == null) {
			return;
		}

		Level level = parkingSpot.getLevel();
		int row = parkingSpot.getRow();
		int index = parkingSpot.getIndex();

		level.unparkVehicle(this, row, index);
		parkingSpot = null;
	}
}
