package blueprint.com.sage.admin.semester.fragments;

import android.app.Activity;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.app.AlertDialog;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import blueprint.com.sage.R;
import blueprint.com.sage.events.semesters.PauseSemesterEvent;
import blueprint.com.sage.models.Semester;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.interfaces.BaseInterface;
import blueprint.com.sage.utility.network.NetworkUtils;
import blueprint.com.sage.utility.view.DateUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import de.greenrobot.event.EventBus;

/**
 * Created by kelseylam on 6/25/16.
 */
public class PauseSemesterFragment extends Fragment {

    BaseInterface mBaseInterface;

    @Bind(R.id.pause_semester_date_range) TextView mDateRange;

    public static PauseSemesterFragment newInstance() { return new PauseSemesterFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        mBaseInterface = (BaseInterface) getActivity();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_pause_semester, parent, false);
        ButterKnife.bind(this, view);
        initializeViews();
        return view;
    }

    private void initializeViews() {
        String startDate = DateUtils.getFormattedDateNow(DateUtils.ABBREV_YEAR_FORMAT);
        String endDate = DateUtils.getDateInAWeek();

        mDateRange.setText(getResources().getString(R.string.pause_semester_date).format(startDate, endDate));
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

    @OnClick(R.id.pause_semester_button)
    public void onPauseSemester(View view) {
        confirmPause();
    }

    public void confirmPause() {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        builder.setMessage(R.string.pause_semester_confirm);
        builder.setCancelable(true);
        builder.setPositiveButton(
                R.string.pause_semester_yes,
                new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        Requests.Semesters.with(getActivity()).makePauseRequest(mBaseInterface.getCurrentSemester());
                    }
                });

        builder.setNegativeButton(
                R.string.pause_semester_no,
                new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        dialog.dismiss();
                    }
                });

        AlertDialog alert = builder.create();
        alert.show();
    }

    public void onEvent(PauseSemesterEvent event) {
        

        Semester semester = event.getSemester();
        Intent intent = new Intent();
        Bundle bundle = new Bundle();
        bundle.putString(getString(R.string.pause_semester),
                NetworkUtils.writeAsString(getActivity(), semester));
        intent.putExtras(bundle);
        getActivity().setResult(Activity.RESULT_OK, intent);
        getActivity().onBackPressed();
    }
}
