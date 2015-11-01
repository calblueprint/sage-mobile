package blueprint.com.sage.checkIn.fragments;

import android.app.AlertDialog;
import android.app.DatePickerDialog;
import android.app.Dialog;
import android.app.TimePickerDialog;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.design.widget.Snackbar;
import android.support.v4.app.DialogFragment;
import android.text.format.DateFormat;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.TimePicker;

import com.android.volley.Response;

import org.joda.time.DateTime;

import java.util.Calendar;

import blueprint.com.sage.R;
import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.CheckIn;
import blueprint.com.sage.models.School;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.check_ins.CreateCheckInRequest;
import blueprint.com.sage.utility.DateUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by charlesx on 10/27/15.
 * Fragment to make a checkin request.
 */
public class CheckInRequestFragment extends CheckInAbstractFragment {

    @Bind(R.id.check_in_request_date_field) TextView mDate;
    @Bind(R.id.check_in_request_start_field) TextView mStartTime;
    @Bind(R.id.check_in_request_end_field) TextView mEndTime;
    @Bind(R.id.check_in_request_total_field) TextView mTotalTime;
    @Bind(R.id.check_in_request_comments_field) EditText mComments;
    @Bind(R.id.check_in_request_cancel_button) Button mDeleteRequest;
    @Bind(R.id.check_in_request_layout) RelativeLayout mLayout;

    private static String DATE_PICKER = "datePicker";
    private static String TIME_PICKER = "timePicker";

    public static CheckInRequestFragment newInstance() { return new CheckInRequestFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_check_in_request, parent, false);
        ButterKnife.bind(this, view);
        initializeViews();
        return view;
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        menu.clear();
        inflater.inflate(R.menu.menu_save, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.menu_save:
                validateAndSubmitRequest();
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    private void initializeViews() {
        if (!getParentActivity().hasPreviousRequest()) { return; }

        SharedPreferences sharedPreferences = getParentActivity().getSharedPreferences();
        String startString = sharedPreferences.getString(getString(R.string.check_in_start_time), "");
        String endString = sharedPreferences.getString(getString(R.string.check_in_end_time), "");

        DateTime startDate = DateUtils.stringToDate(startString);
        DateTime endDate = DateUtils.stringToDate(endString);

        mDate.setText(DateUtils.getFormattedDate(startDate));
        mStartTime.setText(DateUtils.getFormattedTime(startDate));
        mEndTime.setText(DateUtils.getFormattedTime(endDate));
        mTotalTime.setText(DateUtils.timeDiff(startDate, endDate));
    }

    @OnClick({ R.id.check_in_request_start_field, R.id.check_in_request_end_field})
    public void onTimeFieldClick(TextView textView) {
        if (getParentActivity().hasPreviousRequest()) return;

        TimePickerFragment picker = TimePickerFragment.newInstance(textView);
        picker.show(getFragmentManager(), TIME_PICKER);
    }

    @OnClick(R.id.check_in_request_date_field)
    public void onDateFieldClick(TextView textView) {
        if (getParentActivity().hasPreviousRequest()) return;

        DatePickerFragment picker = new DatePickerFragment();
        picker.show(getFragmentManager(), DATE_PICKER);
    }

    @OnClick(R.id.check_in_request_cancel_button)
    public void onDeleteClick(Button button) {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity())
                .setTitle(R.string.check_in_request_delete_title)
                .setMessage(R.string.check_in_request_delete_body)
                .setPositiveButton(R.string.delete,
                        new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                resetCheckIn();
                            }
                        })
                .setNegativeButton(R.string.cancel,
                        new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                dialog.dismiss();
                            }
                        });
        builder.show();
    }

    private void validateAndSubmitRequest() {
        String start = mStartTime.getText().toString();
        String end = mEndTime.getText().toString();
        String date = mDate.getText().toString();

        User user = getParentActivity().getUser();
        School school = getParentActivity().getSchool();

        if (areFieldsEmpty(start, end, date)) {
            Snackbar.make(mLayout, R.string.check_in_request_blank, Snackbar.LENGTH_SHORT).show();
            return;
        }

        String startDateString = String.format("%s %s", date, start);
        String endDateString = String.format("%s %s", date, end);

        DateTime startDate = DateUtils.stringToDate(startDateString);
        DateTime endDate = DateUtils.stringToDate(endDateString);

        if (!startDate.isBefore(endDate)) {
            Snackbar.make(mLayout, R.string.check_in_request_blank, Snackbar.LENGTH_SHORT).show();
        }

        CheckIn checkIn = new CheckIn(startDate.toDate(), endDate.toDate(), user, school);
        createCheckInRequest(checkIn);
    }

    private boolean areFieldsEmpty(String... params) {
        for (String param : params) {
            if (param.isEmpty()) return true;
        }
        return false;
    }

    private void resetCheckIn() {
        getParentActivity().getSharedPreferences()
                           .edit()
                           .remove(getString(R.string.check_in_start_time))
                           .remove(getString(R.string.check_in_end_time))
                           .apply();
        getFragmentManager().popBackStack();
    }

    private void createCheckInRequest(CheckIn checkIn) {
        CreateCheckInRequest request = new CreateCheckInRequest(getParentActivity(), checkIn,
                new Response.Listener<CheckIn>() {
                    @Override
                    public void onResponse(CheckIn checkIn) {
                        resetCheckIn();
                    }
                },
                new Response.Listener<APIError>() {
                    @Override
                    public void onResponse(APIError error) {

                    }
                });

        getParentActivity().getNetworkManager().getRequestQueue().add(request);
    }

    /**
     * Pickers for both date and time
     */

    public static class TimePickerFragment extends DialogFragment
            implements TimePickerDialog.OnTimeSetListener {

        private TextView mTextView;

        public static TimePickerFragment newInstance(TextView textView) {
            TimePickerFragment fragment = new TimePickerFragment();
            fragment.setTextView(textView);
            return fragment;
        }

        public void setTextView(TextView textView) { mTextView = textView; }

        @NonNull
        @Override
        public Dialog onCreateDialog(Bundle savedInstanceState) {
            // Use the current time as the default values for the picker
            final Calendar c = Calendar.getInstance();
            int hour = c.get(Calendar.HOUR_OF_DAY);
            int minute = c.get(Calendar.MINUTE);

            // Create a new instance of TimePickerDialog and return it
            return new TimePickerDialog(getActivity(), this, hour, minute,
                    DateFormat.is24HourFormat(getActivity()));
        }

        public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
            // Do something with the time chosen by the user
        }
    }

    public static class DatePickerFragment extends DialogFragment
            implements DatePickerDialog.OnDateSetListener {

        @NonNull
        @Override
        public Dialog onCreateDialog(Bundle savedInstanceState) {
            // Use the current date as the default date in the picker
            final Calendar c = Calendar.getInstance();
            int year = c.get(Calendar.YEAR);
            int month = c.get(Calendar.MONTH);
            int day = c.get(Calendar.DAY_OF_MONTH);

            // Create a new instance of DatePickerDialog and return it
            return new DatePickerDialog(getActivity(), this, year, month, day);
        }

        public void onDateSet(DatePicker view, int year, int month, int day) {
            getTargetFragment();
        }
    }
}
