package blueprint.com.sage.check_in.fragments;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.ColorStateList;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.provider.Settings;
import android.support.design.widget.CoordinatorLayout;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import com.android.volley.Response;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapView;
import com.google.android.gms.maps.MapsInitializer;
import com.google.android.gms.maps.OnMapReadyCallback;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import blueprint.com.sage.R;
import blueprint.com.sage.models.CheckIn;
import blueprint.com.sage.models.School;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.check_ins.CreateCheckInRequest;
import blueprint.com.sage.utility.network.NetworkManager;
import blueprint.com.sage.utility.network.NetworkUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by charlesx on 10/16/15.
 * Fragment for check in map.
 */
public class CheckInMapFragment extends CheckInAbstractFragment implements OnMapReadyCallback {

    @Bind(R.id.check_in_coordinator) CoordinatorLayout mContainer;
    @Bind(R.id.check_in_check_fab) FloatingActionButton mCheckButton;
    @Bind(R.id.check_in_location_fab) FloatingActionButton mLocationButton;
    @Bind(R.id.check_in_map) MapView mMapView;

    private GoogleMap mMap;
    private SharedPreferences mPreferences;
    private NetworkManager mManager;

    public static CheckInMapFragment newInstance() { return new CheckInMapFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        MapsInitializer.initialize(getActivity());
        mPreferences = getActivity().getSharedPreferences(getString(R.string.preferences),
                                                          Context.MODE_PRIVATE);
        mManager = NetworkManager.getInstance(getActivity());
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
    }

    @Override
    public void onPause() {
        super.onPause();
        mMapView.onPause();
    }

    @Override
    public void onMapReady(GoogleMap map) {
        map.getUiSettings().setCompassEnabled(false);
        mMap = map;
    }

    private void initializeViews(Bundle savedInstanceState) {
        mMapView.onCreate(savedInstanceState);
        mMapView.getMapAsync(this);
    }

    @OnClick(R.id.check_in_location_fab)
    public void onLocationClick(Button button) {
        if (NetworkUtils.hasLocationServiceEnabled(getParentActivity())) {

        }
    }

    @OnClick(R.id.check_in_location_fab)
    public void onCheckInClick(Button button) {
        String startTime = mPreferences.getString(getString(R.string.check_in_start_time), "");
        // We get here when we hit the check
        if (startTime.isEmpty()) {
            if (NetworkUtils.hasLocationServiceEnabled(getParentActivity())) {


            }
        } else {
//            stopCheckIn();
            toggleButton(true);
        }
    }

    private void showOutOfBoundsDialog() {
//        new AlertDialog.Builder(getActivity()).setMessage().show();
    }

    private void showStopCheckInDialog() {
//        new AlertDialog.Builder(getActivity()).setMessage().show();
    }

    private void showEnableLocationDialog() {
        new AlertDialog.Builder(getActivity())
                .setTitle(R.string.check_in_location_off_title)
                .setMessage(R.string.check_in_location_off_title)
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
                })
                .show();
    }

    private void openLocationSettings() {
        Intent intent = new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
        startActivity(intent);
    }


    private boolean checkBounds() {
        return true;
    }

    private void startCheckIn() {
        mPreferences.edit().putString(getString(R.string.check_in_start_time),
                                      getFormattedTimeNow()).apply();
        toggleButton(false);
    }



    private void stopCheckIn(String endTime) {
        String startTime = mPreferences.getString(getString(R.string.check_in_start_time), "");
        if (startTime.isEmpty()) {
            Snackbar.make(mContainer, R.string.check_in_request_error, Snackbar.LENGTH_SHORT).show();
        }

        User user = getParentActivity().getManager().getUser();
        School school = getParentActivity().getManager().getSchool();
        CheckIn checkin  = new CheckIn(startTime, endTime, user, school);

        CreateCheckInRequest request = new CreateCheckInRequest(getParentActivity(), checkin,
                new Response.Listener<CheckIn>() {
                    @Override
                    public void onResponse(CheckIn checkIn) {
                        toggleButton(true);
                    }
                },
                new Response.Listener() {
                    @Override
                    public void onResponse(Object o) {
                    }
                });

        mManager.getRequestQueue().add(request);
    }

    private String getFormattedTimeNow() {
        DateFormat datetime = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss", Locale.ENGLISH);
        return datetime.format(new Date());
    }

    /**
     * Toggles buttons.
     * If showCheckIn is true, then we show the start icon.
     * Else, we show the stop icon.
     * @param showCheckIn boolean
     */
    @SuppressWarnings("deprecation")
    private void toggleButton(boolean showCheckIn) {
        int icon = showCheckIn ? R.drawable.ic_done_white : R.drawable.ic_clear_white;
        int color = showCheckIn ? R.color.green500 : R.color.red500;

        Drawable drawable;
        if (android.os.Build.VERSION.SDK_INT >= 21) {
            drawable = getResources().getDrawable(icon, getActivity().getTheme());
        } else {
            drawable = getResources().getDrawable(icon);
        }

        mCheckButton.setImageDrawable(drawable);
        mCheckButton.setBackgroundTintList(ColorStateList.valueOf(getResources().getColor(color)));
    }
}
