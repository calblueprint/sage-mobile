package blueprint.com.sage.checkIn.fragments;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.ColorStateList;
import android.graphics.drawable.Drawable;
import android.location.Location;
import android.os.Bundle;
import android.provider.Settings;
import android.support.design.widget.CoordinatorLayout;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
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
import org.joda.time.Seconds;

import blueprint.com.sage.R;
import blueprint.com.sage.checkIn.CheckInTimer;
import blueprint.com.sage.models.School;
import blueprint.com.sage.shared.interfaces.BaseInterface;
import blueprint.com.sage.shared.views.FloatingTextView;
import blueprint.com.sage.utility.DateUtils;
import blueprint.com.sage.utility.network.NetworkManager;
import blueprint.com.sage.utility.network.NetworkUtils;
import blueprint.com.sage.utility.view.FragUtils;
import blueprint.com.sage.utility.view.MapUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by charlesx on 10/16/15.
 * Fragment for check in map.
 */
public class CheckInMapFragment extends Fragment
                                implements OnMapReadyCallback {

    private final static int TIMER_INTERVAL = 1000;

    @Bind(R.id.check_in_coordinator) CoordinatorLayout mContainer;
    @Bind(R.id.check_in_check_fab) FloatingActionButton mCheckButton;
    @Bind(R.id.check_in_location_fab) FloatingActionButton mLocationButton;
    @Bind(R.id.check_in_map) MapView mMapView;
    @Bind(R.id.check_in_map_timer) FloatingTextView mTimerText;

    private GoogleMap mMap;
    private NetworkManager mManager;

    private Runnable mRunnableTimer;
    private CheckInTimer mTimer;

    private BaseInterface mBaseInterface;

    public static CheckInMapFragment newInstance() { return new CheckInMapFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        MapsInitializer.initialize(getActivity());
        mManager = NetworkManager.getInstance(getActivity());
        mRunnableTimer = new Runnable() {
            @Override
            public void run() {
                updateTimer();
            }
        };

        mTimer = new CheckInTimer(getActivity(), TIMER_INTERVAL, mRunnableTimer);
        mBaseInterface = (BaseInterface) getActivity();
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
        if (hasStartedCheckIn())
            mTimer.start();
    }

    @Override
    public void onPause() {
        super.onPause();
        mMapView.onPause();

        if (hasStartedCheckIn())
            mTimer.stop();
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        menu.clear();
        inflater.inflate(R.menu.menu_check_in_map, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.menu_request:
                FragUtils.replaceBackStack(R.id.container, CreateCheckInFragment.newInstance(), getActivity());
                break;
        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onMapReady(GoogleMap map) {
        map.getUiSettings().setCompassEnabled(false);
        mMap = map;
        mMap.setMyLocationEnabled(true);
        mMap.getUiSettings().setMyLocationButtonEnabled(false);
        mMap.moveCamera(CameraUpdateFactory.zoomTo(MapUtils.ZOOM));

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
    }

    private void initializeViews(Bundle savedInstanceState) {
        mMapView.onCreate(savedInstanceState);
        mMapView.getMapAsync(this);

        toggleButtons();
        toggleTimer(hasStartedCheckIn());
    }


    /**
     * Super hacky, but whateves
     */
    private void updateTimer() {
        int secondsPassed = getStartTime();
        Log.e("asdf", "" + secondsPassed);
        int hours = secondsPassed / 3600;
        int minutes = (secondsPassed % 3600) / 60;

        String hourString = hours < 10 ? "0" + hours : "" + hours;
        String minutesString = minutes < 10 ? "0" + minutes : "" + minutes;

        String hourMinutes = String.format("%s:%s", hourString, minutesString);
        mTimerText.setText(hourMinutes);
    }

    @OnClick(R.id.check_in_location_fab)
    public void onLocationClick(FloatingActionButton button) { checkAndMoveLocation(); }

    private void checkAndMoveLocation() {
        if (!NetworkUtils.hasLocationServiceEnabled(getActivity())) {
            showEnableLocationDialog();
        } else {
            moveToCurrentLocation();
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
    }

    @OnClick(R.id.check_in_check_fab)
    public void onCheckInClick(FloatingActionButton button) {
        if (!NetworkUtils.hasLocationServiceEnabled(getActivity())) {
            showEnableLocationDialog();
            return;
        }

        if (!locationInBounds()) {
            showOutOfBoundsDialog();
            return;
        }

        if (hasStartedCheckIn()) {
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
                .setNegativeButton(R.string.check_in_start_return,
                        new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                dialog.dismiss();
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
        if (location == null)
            return false;

        School school = mBaseInterface.getSchool();
        float[] results = new float[1];
        Location.distanceBetween(location.getLatitude(), location.getLongitude(), school.getLat(), school.getLng(), results);

        return results[0] <= MapUtils.DISTANCE;
    }

    private Location getLocation() {
        GoogleApiClient client = mBaseInterface.getGoogleApiClient();

        if (client == null)
            return null;

        return LocationServices.FusedLocationApi.getLastLocation(client);
    }

    private void startCheckIn() {
        mBaseInterface.getSharedPreferences().edit().putString(getString(R.string.check_in_start_time),
                                      DateUtils.getFormattedTimeNow()).commit();
        toggleButtons();
        toggleTimer(true);
    }


    private void stopCheckIn() {
        if (!hasStartedCheckIn()) {
            Snackbar.make(mContainer, R.string.check_in_request_error, Snackbar.LENGTH_SHORT).show();
        }

        mBaseInterface.getSharedPreferences().edit().putString(getString(R.string.check_in_end_time),
                DateUtils.getFormattedTimeNow()).commit();

        toggleButtons();
        toggleTimer(false);

        FragUtils.replaceBackStack(R.id.container, CreateCheckInFragment.newInstance(), getActivity());
    }


    /**
     * Toggles buttons.
     * If showCheckIn is true, then we show the start icon. And hide the timer.
     * Else, we show the stop icon. And show the timer.
     */
    @SuppressWarnings("deprecation")
    private void toggleButtons() {

        int icon = hasStartedCheckIn() ? R.drawable.ic_clear_white : R.drawable.ic_done_white;
        int color = hasStartedCheckIn() ? R.color.red500 : R.color.green500;

        Drawable drawable;
        if (android.os.Build.VERSION.SDK_INT >= 21) {
            drawable = getResources().getDrawable(icon, getActivity().getTheme());
        } else {
            drawable = getResources().getDrawable(icon);
        }

        mCheckButton.setImageDrawable(drawable);
        mCheckButton.setBackgroundTintList(ColorStateList.valueOf(getResources().getColor(color)));
    }

    private void toggleTimer(boolean shouldShow) {
        if (shouldShow) {
            mTimerText.setVisibility(View.VISIBLE);
            mTimer.start();
        } else {
            mTimerText.setVisibility(View.GONE);
            mTimer.stop();
        }
    }

    private boolean hasStartedCheckIn() {
        return !mBaseInterface.getSharedPreferences().getString(getString(R.string.check_in_start_time), "").isEmpty();
    }

    private int getStartTime() {
        if (!hasStartedCheckIn())
            return 0;

        String startString = mBaseInterface.getSharedPreferences().getString(getString(R.string.check_in_start_time), "");
        DateTime start = DateUtils.stringToDate(startString);
        DateTime end = DateTime.now();
        return Seconds.secondsBetween(start, end).getSeconds();
    }
}
