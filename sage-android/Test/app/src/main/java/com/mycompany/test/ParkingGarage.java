package com.mycompany.test;

import java.util.ArrayList;

public class ParkingGarage {

	private String garageName;
	private int numLevels;
	private ArrayList<Level> levels;

	public ParkingGarage(String name) {
		this.garageName = name;
		this.levels = new ArrayList<Level>();
		this.numLevels = 5;
		for (int i = 0; i < this.numLevels; i++) {
			this.levels.add(new Level(i));
		}
	}

	public ParkingGarage(String name, ArrayList<Level> levels) {
		this.garageName = name;
		this.levels = levels;
		this.numLevels = levels.size();
	}

	public String getGarageName() {
		return garageName;
	}

	public int getNumLevels() {
		return numLevels;
	}

	public int numAvailableSpots(Vehicle vehicle) {
		int sum = 0;

		for (Level level: levels) {
			sum += level.numAvailableSpots(vehicle);
		}
		return sum;
	}

	public ParkingSpot findAvailableSpot(Vehicle vehicle) {
		for (Level level: levels) {
			if (level.numAvailableSpots(vehicle) >= vehicle.getNumSpots()) {
				ParkingSpot spot;
				if (vehicle.getVehicleType() == Vehicle.BUS) {
					spot = level.findStartingSpot(vehicle);
				} else {
					spot = level.findAvailableSpot(vehicle);
				}
				if (spot != null) return spot;
			}
		}
		return null;
	}
}
