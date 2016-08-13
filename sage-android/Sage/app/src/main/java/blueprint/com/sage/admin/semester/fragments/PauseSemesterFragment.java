package blueprint.com.sage.admin.semester.fragments;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import blueprint.com.sage.R;
import blueprint.com.sage.announcements.CreateAnnouncementActivity;
import blueprint.com.sage.events.semesters.PauseSemesterEvent;
import blueprint.com.sage.models.Semester;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.interfaces.BaseInterface;
import blueprint.com.sage.utility.network.NetworkUtils;
import blueprint.com.sage.utility.view.FragUtils;
import butterknife.ButterKnife;
import butterknife.OnClick;
import de.greenrobot.event.EventBus;

/**
 * Created by kelseylam on 6/25/16.
 */
public class PauseSemesterFragment extends Fragment {

    BaseInterface mBaseInterface;

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

    @OnClick(R.id.pause_semester_button)
    public void onPauseSemester(View view) {
        Requests.Semesters.with(getActivity()).makePauseRequest(mBaseInterface.getCurrentSemester());
    }

    @OnClick(R.id.pause_semester_button_cancel)
    public void onCancelPauseSemester(View view) {
        getActivity().onBackPressed();
    }

    public void onEvent(PauseSemesterEvent event) {
        FragUtils.startActivityForResultFragment(getActivity(), this, CreateAnnouncementActivity.class, FragUtils.CREATE_ANNOUNCEMENT_REQUEST_CODE);

        Semester semester = event.getSemester();
        Intent intent = new Intent();
        Bundle bundle = new Bundle();
        bundle.putString(getString(R.string.activity_pause_semester),
                NetworkUtils.writeAsString(getActivity(), semester));
        intent.putExtras(bundle);
        getActivity().setResult(Activity.RESULT_OK, intent);
        getActivity().onBackPressed();
    }
}
