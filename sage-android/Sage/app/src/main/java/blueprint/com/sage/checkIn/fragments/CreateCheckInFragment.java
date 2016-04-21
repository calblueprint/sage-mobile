package blueprint.com.sage.checkIn.fragments;

import android.app.AlertDialog;
import android.app.Dialog;
import android.app.TimePickerDialog;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.design.widget.Snackbar;
import android.support.v4.app.DialogFragment;
import android.support.v4.app.Fragment;
import android.text.format.DateFormat;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.TimePicker;

import org.joda.time.DateTime;

import java.util.Calendar;

import blueprint.com.sage.R;
import blueprint.com.sage.events.checkIns.CheckInEvent;
import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.CheckIn;
import blueprint.com.sage.models.School;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.FormValidation;
import blueprint.com.sage.shared.fragments.dialogs.DateDialog;
import blueprint.com.sage.shared.interfaces.BaseInterface;
import blueprint.com.sage.shared.interfaces.DateInterface;
import blueprint.com.sage.shared.interfaces.ToolbarInterface;
import blueprint.com.sage.utility.model.CheckInUtils;
import blueprint.com.sage.utility.model.SessionUtils;
import blueprint.com.sage.utility.view.DateUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 10/27/15.
 * Fragment to make a checkin request.
 */
public class CreateCheckInFragment extends Fragment implements FormValidation, DateInterface {

    @Bind(R.id.check_in_request_date_field) TextView mDate;
    @Bind(R.id.check_in_request_start_field) TextView mStartTime;
    @Bind(R.id.check_in_request_end_field) TextView mEndTime;
    @Bind(R.id.check_in_request_total_field) TextView mTotalTime;
    @Bind(R.id.check_in_request_comments_field) EditText mComment;
    @Bind(R.id.check_in_request_cancel_button) Button mDeleteRequest;
    @Bind(R.id.check_in_request_layout) RelativeLayout mLayout;

    private static final String DATE_PICKER = "datePicker";
    private static final String TIME_PICKER = "timePicker";

    private static final int REQUEST_CODE = 200;

    private BaseInterface mBaseInterface;
    private ToolbarInterface mToolbarInterface;

    private MenuItem mItem;

    public static CreateCheckInFragment newInstance() { return new CreateCheckInFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mBaseInterface = (BaseInterface) getActivity();
        mToolbarInterface = (ToolbarInterface) getActivity();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_create_check_in, parent, false);
        ButterKnife.bind(this, view);
        initializeViews();
        return view;
    }

    @Override
    public void onStart() {
        super.onStart();
        EventBus.getDefault().register(this);
    }

    @Override
    public void onStop() {
        super.onStop();
        EventBus.getDefault().unregister(this);
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        menu.clear();
        inflater.inflate(R.menu.menu_save, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        mItem = item;
        switch (item.getItemId()) {
            case R.id.menu_save:
                validateAndSubmitRequest();
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    private void initializeViews() {
        if (!CheckInUtils.hasPreviousRequest(getContext(), mBaseInterface)) {
            mToolbarInterface.setTitle("Create Check In");
            mDeleteRequest.setVisibility(View.GONE);
            return;
        }

        SharedPreferences sharedPreferences = mBaseInterface.getSharedPreferences();
        User user = mBaseInterface.getUser();
        String startString = sharedPreferences.getString(getString(R.string.check_in_start_time, user.getId()), "");
        String endString = sharedPreferences.getString(getString(R.string.check_in_end_time, user.getId()), "");

        DateTime startDate = DateUtils.stringToDate(startString);
        DateTime endDate = DateUtils.stringToDate(endString);

        mDate.setText(DateUtils.getFormattedDay(startDate));
        mStartTime.setText(DateUtils.getFormattedTime(startDate));
        mEndTime.setText(DateUtils.getFormattedTime(endDate));
        mTotalTime.setText(DateUtils.timeDiff(startDate, endDate));

        mToolbarInterface.setTitle("Finish Checkin");
    }

    @OnClick({ R.id.check_in_request_start_field, R.id.check_in_request_end_field})
    public void onTimeFieldClick(TextView textView) {
        if (CheckInUtils.hasPreviousRequest(getContext(), mBaseInterface)) return;

        TimePickerFragment picker = TimePickerFragment.newInstance(textView);
        picker.setTargetFragment(this, REQUEST_CODE);
        picker.show(getFragmentManager(), TIME_PICKER);
    }

    public void setTime(TextView textView, int hourOfDay, int minute) {
        String timeString = String.format("%d:%d", hourOfDay, minute);
        DateTime dateTime = DateUtils.getDateTime(timeString, DateUtils.HOUR_FORMAT);

        textView.setText(DateUtils.getFormattedTime(dateTime));

        String startString = mStartTime.getText().toString();
        String endString = mEndTime.getText().toString();
        if (!startString.isEmpty() && !endString.isEmpty()) {
            mTotalTime.setText(DateUtils.timeDiff(DateUtils.getDateTime(startString, DateUtils.TIME_FORMAT),
                                                  DateUtils.getDateTime(endString, DateUtils.TIME_FORMAT)));
        }
    }

    @OnClick(R.id.check_in_request_date_field)
    public void onDateFieldClick(TextView textView) {
        if (CheckInUtils.hasPreviousRequest(getContext(), mBaseInterface)) return;

        DateDialog picker = DateDialog.newInstance(textView, this);
        picker.setTargetFragment(this, REQUEST_CODE);
        picker.show(getFragmentManager(), DATE_PICKER);
    }

    public void setDate(TextView textView, int year, int month, int day) {
        String timeString = String.format("%d/%d/%d", year, month, day);
        DateTime dateTime = DateUtils.getDateTime(timeString, DateUtils.YEAR_FORMAT);

        textView.setText(DateUtils.getFormattedDay(dateTime));
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

    public void validateAndSubmitRequest() {
        String start = mStartTime.getText().toString();
        String end = mEndTime.getText().toString();
        String date = mDate.getText().toString();
        String comment = mComment.getText().toString();

        User user = mBaseInterface.getUser();
        School school = mBaseInterface.getSchool();

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

        mItem.setActionView(R.layout.actionbar_indeterminate_progress);
        CheckIn checkIn = new CheckIn(startDate.toDate(), endDate.toDate(), user, school, comment);
        Requests.CheckIns.with(getActivity()).makeCreateRequest(checkIn);
    }

    private boolean areFieldsEmpty(String... params) {
        for (String param : params) {
            if (param.isEmpty()) return true;
        }
        return false;
    }

    private void resetCheckIn() {
        SessionUtils.updateRequestCount(getActivity(), 1, R.string.admin_check_in_requests);
        CheckInUtils.resetCheckIn(getActivity(), mBaseInterface);
        getActivity().onBackPressed();
    }

    public void onEvent(CheckInEvent event) { resetCheckIn();}

    public void onEvent(APIError event) { mItem.setActionView(null); }

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
            if (getTargetFragment() instanceof CreateCheckInFragment) {
                CreateCheckInFragment fragment = (CreateCheckInFragment) getTargetFragment();
                fragment.setTime(mTextView, hourOfDay, minute);
            }
        }
    }
}
