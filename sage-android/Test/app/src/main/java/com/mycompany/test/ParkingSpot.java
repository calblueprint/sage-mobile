package com.mycompany.test;

public class ParkingSpot {

	private Level level;
	private int row;
	private int index;
	private String spotType;
	private Vehicle parkedVehicle;

	public static final String MOTORCYCLE = "Motorcycle";
	public static final String COMPACT = "Compact";
	public static final String LARGE = "Large";

	public ParkingSpot(String spotType, Level level, int row, int index) {
		this.spotType = spotType;
		this.level = level;
		this.row = row;
		this.index = index;
	}

	public String getSpotType() {
		return spotType;
	}

	public Vehicle getParkedVehicle() {
		return parkedVehicle;
	}

	public Level getLevel() {
		return level;
	}

	public int getRow() {
		return row;
	}

	public int getIndex() {
		return index;
	}

	public boolean isOccupied() {
		return parkedVehicle != null;
	}

	public void parkVehicle(Vehicle vehicle) {
		if (!isOccupied()) {
			parkedVehicle = vehicle;
		}
	}

	public void unparkVehicle(Vehicle vehicle) {
		if (isOccupied()) {
			parkedVehicle = null;
		}
	}
}
