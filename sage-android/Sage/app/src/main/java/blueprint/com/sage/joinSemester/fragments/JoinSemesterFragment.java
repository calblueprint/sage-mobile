package blueprint.com.sage.joinSemester.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import blueprint.com.sage.R;
import blueprint.com.sage.events.semesters.JoinSemesterEvent;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.interfaces.BaseInterface;
import blueprint.com.sage.utility.network.NetworkUtils;
import blueprint.com.sage.utility.view.FragUtils;
import butterknife.ButterKnife;
import butterknife.OnClick;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 1/30/16.
 */
public class JoinSemesterFragment extends Fragment {

    private BaseInterface mBaseInterface;

    public static JoinSemesterFragment newInstance() { return new JoinSemesterFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mBaseInterface = (BaseInterface) getActivity();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_join_semester, parent, false);
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

    @OnClick(R.id.join_semester_button)
    public void onJoinSemester() {
        Requests.Semesters.with(getActivity()).makeJoinRequest();
    }

    public void onEvent(JoinSemesterEvent event) {
        try {
            NetworkUtils.setSession(getActivity(), event.getSession());
            Toast.makeText(getActivity(), R.string.join_semester_success, Toast.LENGTH_SHORT).show();
            FragUtils.popBackStack(this);
        } catch (Exception e) {
            Log.e(getClass().toString(), e.toString());
        }
    }
}
