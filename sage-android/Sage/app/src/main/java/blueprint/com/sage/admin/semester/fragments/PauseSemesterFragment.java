package blueprint.com.sage.admin.semester.fragments;

import android.content.DialogInterface;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.app.AlertDialog;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import blueprint.com.sage.R;
import blueprint.com.sage.events.semesters.PauseSemesterEvent;
import blueprint.com.sage.shared.interfaces.BaseInterface;
import blueprint.com.sage.utility.view.FragUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import de.greenrobot.event.EventBus;

/**
 * Created by kelseylam on 6/25/16.
 */
public class PauseSemesterFragment extends Fragment {

    @Bind(R.id.pause_semester_button) Button mPauseSemesterButton;
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
        confirmPause();
    }

    public void confirmPause() {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        builder.setTitle(R.string.pause_semester_confirm_title);
        builder.setMessage(R.string.pause_semester_confirm_msg);
        builder.setCancelable(true);
        builder.setPositiveButton(
                R.string.pause_semester_continue,
                new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        FragUtils.replace(R.id.container, FinishPauseSemesterFragment.newInstance(mBaseInterface.getCurrentSemester()), getActivity());
//                        Requests.Semesters.with(getActivity()).makePauseRequest(mBaseInterface.getCurrentSemester());
                    }
                });

        builder.setNegativeButton(
                R.string.pause_semester_cancel,
                new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        dialog.dismiss();
                    }
                });

        AlertDialog alert = builder.create();
        alert.show();
    }

    @OnClick(R.id.pause_semester_button_cancel)
    public void onCancelPauseSemester(View view) {
        getActivity().onBackPressed();
    }

    public void onEvent(PauseSemesterEvent event) {
//        FragUtils.replace(R.id.container, FinishPauseSemesterFragment.newInstance(event.getSemester()), getActivity());
    }
}
