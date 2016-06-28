package blueprint.com.sage.admin.semester.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import blueprint.com.sage.R;
import blueprint.com.sage.events.semesters.PauseSemesterEvent;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.interfaces.BaseInterface;
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

        mDateRange.setText(getResources().getString(R.string.pause_semester_date).format(startDate, endDate);
        
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
        Requests.Semesters.with(getActivity()).makePauseRequest(mBaseInterface.getCurrentSemester());
    }

    public void onEvent(PauseSemesterEvent event) {
//        Announcement announcement = event.getMAnnouncement();
//        Intent intent = new Intent();
//        Bundle bundle = new Bundle();
//        bundle.putString(getString(R.string.create_announcement),
//                NetworkUtils.writeAsString(getActivity(), announcement));
//        intent.putExtras(bundle);
//        getActivity().setResult(Activity.RESULT_OK, intent);
//        getActivity().onBackPressed();
    }
}
