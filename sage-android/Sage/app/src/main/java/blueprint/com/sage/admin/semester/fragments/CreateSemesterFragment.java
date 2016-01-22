package blueprint.com.sage.admin.semester.fragments;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Spinner;
import android.widget.TextView;

import org.joda.time.DateTime;

import blueprint.com.sage.R;
import blueprint.com.sage.events.semesters.StartSemesterEvent;
import blueprint.com.sage.models.Semester;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.FormValidation;
import blueprint.com.sage.shared.adapters.spinners.StringArraySpinnerAdapter;
import blueprint.com.sage.shared.fragments.dialogs.DateDialog;
import blueprint.com.sage.shared.interfaces.DateInterface;
import blueprint.com.sage.shared.validators.FormValidator;
import blueprint.com.sage.utility.view.DateUtils;
import blueprint.com.sage.utility.network.NetworkUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 1/6/16.
 * Fragment to start a semester
 */
public class CreateSemesterFragment extends Fragment implements FormValidation, DateInterface {

    @Bind(R.id.create_semester_layout) View view;
    @Bind(R.id.create_semester_season) Spinner mSpinner;
    @Bind(R.id.create_semester_date) TextView mStartDate;

    private StringArraySpinnerAdapter mAdapter;
    private FormValidator mValidator;

    private final int REQUEST_CODE = 200;
    private final String DIALOG_TAG = "CreateSemesterFragment";

    public static CreateSemesterFragment newInstance() { return new CreateSemesterFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mValidator = FormValidator.newInstance(getActivity());
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_create_semester, parent, false);
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
                showConfirmDialog();
            default:
                return super.onOptionsItemSelected(item);
        }
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

    private void initializeViews() {
        mAdapter = new StringArraySpinnerAdapter(getActivity(),
                                                 Semester.SEASONS,
                                                 R.layout.simple_spinner_item,
                                                 R.layout.simple_spinner_item);
        mSpinner.setAdapter(mAdapter);
    }

    private void showConfirmDialog() {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity())
                .setTitle(R.string.semester_start_confirm_title)
                .setMessage(R.string.semester_start_confirm_message)
                .setPositiveButton(R.string.continue_confirm,
                        new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                validateAndSubmitRequest();
                            }
                        })
                .setNegativeButton(R.string.cancel,
                        new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialogInterface, int i) {
                                dialogInterface.dismiss();
                            }
                        });
        builder.show();
    }

    @OnClick(R.id.create_semester_date)
    public void onDateClick(TextView textView) {
        DateDialog dateDialog = DateDialog.newInstance(textView, this);

        dateDialog.setTargetFragment(this, REQUEST_CODE);
        dateDialog.show(getFragmentManager(), DIALOG_TAG);
    }

    public void setDate(TextView textView, int year, int month, int day) {
        String timeString = String.format("%d/%d/%d", year, month, day);
        DateTime dateTime = DateUtils.getDateTime(timeString, DateUtils.YEAR_FORMAT);

        textView.setText(DateUtils.getFormattedDay(dateTime));
    }

    public void validateAndSubmitRequest() {
        if (!isValid()) {
            return;
        }

        Semester semester = new Semester();

        String startDate = mStartDate.getText().toString();
        semester.setStart(DateUtils.getDateTime(startDate, DateUtils.DAY_FORMAT).toDate());
        semester.setSeason(mSpinner.getSelectedItemPosition());

        Requests.Semesters.with(getActivity()).makeStartRequest(semester);
    }

    private boolean isValid() {
        return mValidator.mustBePicked(mStartDate, "Start Date", view);
    }

    public void onEvent(StartSemesterEvent event) {
        Semester semester = event.getSemester();

        Intent intent = new Intent();
        Bundle bundle = new Bundle();
        bundle.putString(getString(R.string.activity_create_semester),
                NetworkUtils.writeAsString(getActivity(), semester));
        intent.putExtras(bundle);

        getActivity().setResult(Activity.RESULT_OK, intent);
        getActivity().onBackPressed();
    }
}
