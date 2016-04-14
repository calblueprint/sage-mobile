package com.mycompany.test;

import java.util.HashMap;
import java.util.ArrayList;

public class Level {

	private int levelNumber;
	private int numRows;
	private int numSpotsInRow;
	private HashMap<Integer, ArrayList<ParkingSpot>> rows;
	private HashMap<Integer, Integer> availableMotorcycleSpots;
	private HashMap<Integer, Integer> availableCompactSpots;
	private HashMap<Integer, Integer> availableLargeSpots;

	public Level(int levelNumber) {
		this.levelNumber = levelNumber;
		numRows = 10;
		numSpotsInRow = 10;
		rows = new HashMap<Integer, ArrayList<ParkingSpot>>();
		availableMotorcycleSpots = new HashMap<Integer, Integer>();
		availableCompactSpots = new HashMap<Integer, Integer>();
		availableLargeSpots = new HashMap<Integer, Integer>();

		for (int i = 0; i < numRows; i++) {
			ArrayList<ParkingSpot> row = new ArrayList<ParkingSpot>();
			for (int j = 0; j < numSpotsInRow; j++) {
				ParkingSpot spot;
				if (j < 2) {
					spot = new ParkingSpot(ParkingSpot.MOTORCYCLE, this, i, j);
				} else if  (j < 4) {
					spot = new ParkingSpot(ParkingSpot.COMPACT, this, i, j);
				} else {
					spot = new ParkingSpot(ParkingSpot.LARGE, this, i, j);
				}
				row.add(spot);
			}
			rows.put(i, row);
			availableMotorcycleSpots.put(i, 2);
			availableCompactSpots.put(i, 3);
			availableLargeSpots.put(i, 5);
		}
	}

	public Level(int levelNumber, HashMap<Integer, ArrayList<ParkingSpot>> rows) {
		this.levelNumber = levelNumber;
		this.rows = rows;
		this.numRows = rows.size();
		if (!rows.isEmpty()) {
			this.numSpotsInRow = rows.get(0).size();
		} else {
			this.numSpotsInRow = 0;
		}

		//availablespots
	}

	public int getLevelNumber() {
		return levelNumber;
	}

	public int getNumRows() {
		return numRows;
	}

	public int getNumSpotsInRow() {
		return numSpotsInRow;
	}

	public int numAvailableSpotsForRow(Vehicle vehicle, int row) {
		String vehicleType;
		if (vehicle == null) {
			vehicleType = null;
		} else {
			vehicleType = vehicle.getVehicleType();
		}

		switch (vehicleType) {
			case Vehicle.CAR:
				return availableCompactSpots.get(row) + availableLargeSpots.get(row);
			case Vehicle.BUS:
				return availableLargeSpots.get(row);
			default:
				return availableMotorcycleSpots.get(row) + availableCompactSpots.get(row) + availableLargeSpots.get(row);
		}
	}

	public int numAvailableSpots(Vehicle vehicle) {
		int sum = 0;

		for (int i = 0; i < numRows; i++) {
			sum += numAvailableSpotsForRow(vehicle, i);
		}
		return sum;
	}

	public ParkingSpot findAvailableSpot(Vehicle vehicle) {
		for (int i = 0; i < numRows; i++) {
			if (numAvailableSpotsForRow(vehicle, i) > 0) {
				for (int j = 0; j < numSpotsInRow; j++) {
					ParkingSpot spot = rows.get(i).get(j);
					if (!spot.isOccupied()) return spot;
				}
			}
		}
		return null;
	}

	public ParkingSpot findStartingSpot(Vehicle vehicle) {
		for (int i = 0; i < numRows; i++) {
			if (numAvailableSpotsForRow(vehicle, i) >= vehicle.getNumSpots()) {
				ParkingSpot spot = consecutiveRowSpots(i, vehicle.getNumSpots());
				if (spot != null) return spot;
			}
		}
		return null;
	}

	public ParkingSpot consecutiveRowSpots(int row, int numSpots) {
		int spotCounter = numSpots;
		for (int i = 0; i < numSpotsInRow; i++) {
			ParkingSpot spot = rows.get(row).get(i);

			if (spot.getSpotType() != ParkingSpot.LARGE) {
				spotCounter = numSpots;
			} else {
				spotCounter -= 1;
			}

			if (spotCounter == 0) {
				spot = rows.get(row).get(i - numSpots - 1);
				return spot;
			}
		}
		return null;
	}

	//assumes you can park
	public void parkVehicle(Vehicle vehicle, int row, int index) {
		ParkingSpot spot = rows.get(row).get(index);

		if (vehicle.getVehicleType() == Vehicle.BUS && spot.getSpotType() == ParkingSpot.LARGE) {
			for (int i = index; i < 5; i++) {
				spot = rows.get(row).get(i);
				spot.parkVehicle(vehicle);
			}
			availableLargeSpots.put(row, availableLargeSpots.get(row) - 5);

		} else {
			String spotType = spot.getSpotType();

			switch (spotType) {
				case ParkingSpot.MOTORCYCLE:
					availableMotorcycleSpots.put(row, availableMotorcycleSpots.get(row) - 1);
					break;
				case ParkingSpot.COMPACT:
					availableCompactSpots.put(row, availableCompactSpots.get(row) - 1);
					break;
				case ParkingSpot.LARGE:
					availableLargeSpots.put(row, availableLargeSpots.get(row) - 1);
			}
			spot.parkVehicle(vehicle);
		}
	}

	//assumes you can park
	public void unparkVehicle(Vehicle vehicle, int row, int index) {
		ParkingSpot spot = rows.get(row).get(index);

		if (vehicle.getVehicleType() == Vehicle.BUS && spot.getSpotType() == ParkingSpot.LARGE) {
			for (int i = index; i < 5; i++) {
				spot = rows.get(row).get(i);
				spot.unparkVehicle(vehicle);
			}
			availableLargeSpots.put(row, availableLargeSpots.get(row) + 5);

		} else {
			String spotType = spot.getSpotType();

			switch (spotType) {
				case ParkingSpot.MOTORCYCLE:
					availableMotorcycleSpots.put(row, availableMotorcycleSpots.get(row) + 1);
					break;
				case ParkingSpot.COMPACT:
					availableCompactSpots.put(row, availableCompactSpots.get(row) + 1);
					break;
				case ParkingSpot.LARGE:
					availableLargeSpots.put(row, availableLargeSpots.get(row) + 1);
			}
			spot.unparkVehicle(vehicle);
		}
	}
}
