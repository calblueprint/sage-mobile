package blueprint.com.sage.main.fragments;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.ColorStateList;
import android.location.Location;
import android.os.Bundle;
import android.os.SystemClock;
import android.provider.Settings;
import android.support.design.widget.CoordinatorLayout;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapView;
import com.google.android.gms.maps.MapsInitializer;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.model.LatLng;

import org.joda.time.DateTime;

import blueprint.com.sage.R;
import blueprint.com.sage.checkIn.CheckInActivity;
import blueprint.com.sage.checkIn.CheckInTimer;
import blueprint.com.sage.models.School;
import blueprint.com.sage.shared.interfaces.BaseInterface;
import blueprint.com.sage.shared.views.FloatingTextView;
import blueprint.com.sage.utility.PermissionsUtils;
import blueprint.com.sage.utility.model.CheckInUtils;
import blueprint.com.sage.utility.network.NetworkUtils;
import blueprint.com.sage.utility.view.DateUtils;
import blueprint.com.sage.utility.view.FragUtils;
import blueprint.com.sage.utility.view.MapUtils;
import blueprint.com.sage.utility.view.ViewUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by charlesx on 10/16/15.
 * Fragment for check in map.
 */
public class CheckInMapFragment extends Fragment
                                implements OnMapReadyCallback,
                                           GoogleApiClient.ConnectionCallbacks {

    private final static int TIMER_INTERVAL = 1000;
    private final static int SIX_HOURS = 21600;

    @Bind(R.id.check_in_coordinator) CoordinatorLayout mContainer;
    @Bind(R.id.check_in_check_fab) FloatingActionButton mCheckButton;
    @Bind(R.id.check_in_map) MapView mMapView;
    @Bind(R.id.check_in_map_timer) FloatingTextView mTimerText;

    private GoogleMap mMap;

    private CheckInTimer mTimer;

    private BaseInterface mBaseInterface;

    public static CheckInMapFragment newInstance() { return new CheckInMapFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Runnable runnableTimer = new Runnable() {
            @Override
            public void run() {
                updateTimer();
            }
        };

        mTimer = new CheckInTimer(getActivity(), TIMER_INTERVAL, runnableTimer);
        mBaseInterface = (BaseInterface) getActivity();
        if (mBaseInterface.getGoogleApiClient() != null)
            mBaseInterface.getGoogleApiClient().registerConnectionCallbacks(this);
        MapsInitializer.initialize(getActivity());
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_check_in_map, parent, false);
        ButterKnife.bind(this, view);
        initializeViews(savedInstanceState);
        return view;
    }

    @Override
    public void onResume() {
        super.onResume();
        mMapView.onResume();
        toggleButtons();
        toggleTimer();
        if (CheckInUtils.hasPreviousRequest(getContext(), mBaseInterface))
            mTimer.start();
    }

    @Override
    public void onPause() {
        super.onPause();
        mMapView.onPause();

        if (CheckInUtils.hasPreviousRequest(getContext(), mBaseInterface))
            mTimer.stop();
    }

    @Override
    public void onConnected(Bundle bundle) { setUpMap(); }

    @Override
    public void onConnectionSuspended(int i) {}

    @Override
    public void onMapReady(GoogleMap map) {
        map.getUiSettings().setCompassEnabled(false);
        mMap = map;
        mMap.getUiSettings().setMyLocationButtonEnabled(false);
        mMap.moveCamera(CameraUpdateFactory.zoomTo(MapUtils.ZOOM));
        setUpMap();
    }

    public void setUpMap() {
        if (!PermissionsUtils.hasLocationPermissions(getActivity())) {
            LatLng latLng = new LatLng(MapUtils.DEFAULT_LAT, MapUtils.DEFAULT_LONG);
            mMap.moveCamera(CameraUpdateFactory.newLatLng(latLng));
            PermissionsUtils.requestLocationPermissions(getParentFragment());
            return;
        }

        if (NetworkUtils.hasLocationServiceEnabled(getActivity())) {
            Location location = getLocation();

            LatLng latLng;
            if (location == null) {
                latLng = new LatLng(MapUtils.DEFAULT_LAT, MapUtils.DEFAULT_LONG);
            } else {
                latLng = new LatLng(location.getLatitude(), location.getLongitude());
            }

            mMap.moveCamera(CameraUpdateFactory.newLatLng(latLng));
        } else {
            LatLng latLng = new LatLng(MapUtils.DEFAULT_LAT, MapUtils.DEFAULT_LONG);
            mMap.moveCamera(CameraUpdateFactory.newLatLng(latLng));
        }

        School school = mBaseInterface.getSchool();
        if (school == null)
            return;

        LatLng latLng = new LatLng(school.getLat(), school.getLng());

        mMap.setMyLocationEnabled(true);
        mMap.addMarker(MapUtils.getMarkerOptions(latLng));
        mMap.addCircle(MapUtils.getCircleOptions(getActivity(), latLng, MapUtils.RADIUS));
    }

    private void initializeViews(Bundle savedInstanceState) {
        mMapView.onCreate(savedInstanceState);
        mMapView.getMapAsync(this);

        toggleButtons();
        toggleTimer();
    }

    /**
     * Super hacky, but whateves
     */
    private void updateTimer() {
        int secondsPassed = getSecondsElapsed();

        if (secondsPassed > SIX_HOURS) {
            resetCheckIn();
            return;
        }

        int hours = secondsPassed / 3600;
        int minutes = (secondsPassed % 3600) / 60;

        String hourString = hours < 10 ? "0" + hours : "" + hours;
        String minutesString = minutes < 10 ? "0" + minutes : "" + minutes;

        String hourMinutes = String.format("%s:%s", hourString, minutesString);
        mTimerText.setText(hourMinutes);
    }

    private void resetCheckIn() {
        CheckInUtils.resetCheckIn(getActivity(), mBaseInterface);
        toggleButtons();
        toggleTimer();
        Snackbar.make(mContainer, R.string.check_in_request_too_long, Snackbar.LENGTH_SHORT).show();
        mTimer.stop();
    }

    private int getSecondsElapsed() {
        if (!CheckInUtils.hasPreviousRequest(getContext(), mBaseInterface))
            return 0;

        Long totalSeconds =  mBaseInterface.getSharedPreferences()
                .getLong(getString(R.string.check_in_total_seconds, mBaseInterface.getUser().getId()), 0);

        Long diffSeconds = SystemClock.elapsedRealtime() -
                mBaseInterface.getSharedPreferences()
                        .getLong(getString(R.string.check_in_recent_seconds, mBaseInterface.getUser().getId()), SystemClock.elapsedRealtime());

        return (int) Math.floor((totalSeconds + diffSeconds) / 1000);
    }

    @OnClick(R.id.check_in_location_fab)
    public void onLocationClick(FloatingActionButton button) { checkAndMoveLocation(); }

    private void checkAndMoveLocation() {
        if (PermissionsUtils.hasLocationPermissions(getActivity())) {
            if (!NetworkUtils.hasLocationServiceEnabled(getActivity())) {
                showEnableLocationDialog();
            } else {
                moveToCurrentLocation();
            }
        } else {
            PermissionsUtils.requestLocationPermissions(getParentFragment());
        }
    }

    private void moveToCurrentLocation() {
        if (mMap == null)
            return;

        Location location = getLocation();

        if (location == null)
            return;

        LatLng latLng = new LatLng(location.getLatitude(), location.getLongitude());
        mMap.animateCamera(CameraUpdateFactory.newLatLngZoom(latLng, MapUtils.ZOOM));
        mMap.setMyLocationEnabled(true);
    }

    @OnClick(R.id.check_in_check_fab)
    public void onCheckInClick(FloatingActionButton button) {
        if (CheckInUtils.hasPreviousRequest(getContext(), mBaseInterface)) {
            showStopCheckInDialog();
        } else {
            showStartCheckInDialog();
        }
    }

    private void showOutOfBoundsDialog() {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity())
                .setTitle(R.string.check_in_oob_title)
                .setMessage(R.string.check_in_oob_body)
                .setPositiveButton(R.string.check_in_oob_confirm,
                        new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                dialog.dismiss();
                            }
                        });
        builder.show();
    }

    private void showStartCheckInDialog() {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity())
                .setTitle(R.string.check_in_start_title)
                .setMessage(R.string.check_in_start_body)
                .setPositiveButton(R.string.check_in_start_confirm,
                        new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                startCheckIn();
                            }
                        })
                .setNegativeButton(R.string.check_in_request,
                        new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                FragUtils.startActivityBackStack(getActivity(), CheckInActivity.class);
                            }
                        });
        builder.show();
    }

    private void showStopCheckInDialog() {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity())
                .setTitle(R.string.check_in_finish_title)
                .setMessage(R.string.check_in_finish_body)
                .setPositiveButton(R.string.check_in_finish_confirm,
                        new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                stopCheckIn();
                            }
                        })
                .setNegativeButton(R.string.check_in_finish_return,
                        new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                dialog.dismiss();
                            }
                        });
        builder.show();
    }

    private void showEnableLocationDialog() {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity())
                .setTitle(R.string.check_in_location_off_title)
                .setMessage(R.string.check_in_location_off_body)
                .setPositiveButton(R.string.check_in_location_off_confirm,
                        new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                openLocationSettings();
                            }
                        })
                .setNegativeButton(R.string.check_in_location_off_return,
                        new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                dialog.dismiss();
                            }
                        });
        builder.show();
    }

    private void openLocationSettings() {
        Intent intent = new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
        startActivity(intent);
    }

    private boolean locationInBounds() {
        Location location = getLocation();
        School school = mBaseInterface.getSchool();

        if (location == null) {
            return false;
        }

        if (school == null) {
            Snackbar.make(mContainer, R.string.check_in_no_school, Snackbar.LENGTH_SHORT).show();
            return false;
        }

        float[] results = new float[1];
        Location.distanceBetween(location.getLatitude(),
                location.getLongitude(),
                school.getLat(),
                school.getLng(),
                results);

        return results[0] <= MapUtils.DISTANCE;
    }

    private Location getLocation() {
        GoogleApiClient client = mBaseInterface.getGoogleApiClient();

        if (client == null)
            return null;

        return LocationServices.FusedLocationApi.getLastLocation(client);
    }

    private void startCheckIn() {
        if (!PermissionsUtils.hasLocationPermissions(getActivity())) {
            PermissionsUtils.requestLocationPermissions(getParentFragment());
            return;
        } else if (!NetworkUtils.hasLocationServiceEnabled(getActivity())) {
            showEnableLocationDialog();
            return;
        } else if (!locationInBounds()) {
            showOutOfBoundsDialog();
            return;
        }

        mBaseInterface.getSharedPreferences().edit()
                .putString(getString(R.string.check_in_start_time, mBaseInterface.getUser().getId()), DateUtils.getFormattedDateNow())
                .putLong(getString(R.string.check_in_recent_seconds, mBaseInterface.getUser().getId()), SystemClock.elapsedRealtime())
                .putLong(getString(R.string.check_in_total_seconds, mBaseInterface.getUser().getId()), 0)
                .commit();
        toggleButtons();
        toggleTimer();
        Snackbar.make(mContainer, R.string.check_in_start_message, Snackbar.LENGTH_SHORT).show();
    }

    private void stopCheckIn() {
        if (!NetworkUtils.hasLocationServiceEnabled(getActivity())) {
            showEnableLocationDialog();
            return;
        } else if (!locationInBounds()) {
            showOutOfBoundsDialog();
            return;
        } else if (!CheckInUtils.hasPreviousRequest(getContext(), mBaseInterface)) {
            Snackbar.make(mContainer, R.string.check_in_request_error, Snackbar.LENGTH_SHORT).show();
            return;
        }

        String startString = mBaseInterface.getSharedPreferences()
                .getString(getString(R.string.check_in_start_time, mBaseInterface.getUser().getId()), "");
        DateTime start = DateUtils.stringToDate(startString);
        DateTime finish = start.plusSeconds(getSecondsElapsed());

        mBaseInterface.getSharedPreferences().edit()
                .putString(getString(R.string.check_in_end_time, mBaseInterface.getUser().getId()), DateUtils.dateToString(finish))
                .commit();

        toggleButtons();
        toggleTimer();

        FragUtils.startActivityBackStack(getActivity(), CheckInActivity.class);
    }


    /**
     * Toggles buttons.
     * If showCheckIn is true, then we show the start icon. And hide the timer.
     * Else, we show the stop icon. And show the timer.
     */
    private void toggleButtons() {
        boolean hasCheckIn = CheckInUtils.hasPreviousRequest(getContext(), mBaseInterface);
        int icon = hasCheckIn ? R.drawable.ic_clear_white : R.drawable.ic_done_white;
        int color = hasCheckIn ? R.color.red500 : R.color.green500;

        mCheckButton.setImageDrawable(ViewUtils.getDrawable(getActivity(), icon));
        mCheckButton.setBackgroundTintList(ColorStateList.valueOf(getResources().getColor(color)));
    }

    private void toggleTimer() {
        if (CheckInUtils.hasPreviousRequest(getContext(), mBaseInterface)) {
            mTimerText.setVisibility(View.VISIBLE);
            mTimer.start();
        } else {
            mTimerText.setVisibility(View.GONE);
            mTimer.stop();
        }
    }

}
