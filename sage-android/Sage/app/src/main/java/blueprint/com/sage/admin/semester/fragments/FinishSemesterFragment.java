package blueprint.com.sage.admin.semester.fragments;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;

import org.joda.time.DateTime;

import java.util.HashMap;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.events.semesters.FinishSemesterEvent;
import blueprint.com.sage.events.semesters.SemesterListEvent;
import blueprint.com.sage.models.Semester;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.interfaces.BaseInterface;
import blueprint.com.sage.shared.interfaces.ToolbarInterface;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 1/7/16.
 * Finish a semester
 */
public class FinishSemesterFragment extends Fragment {

    @Bind(R.id.finish_semester_layout) View mLayout;
    @Bind(R.id.finish_semester_email) EditText mEmail;

    private List<Semester> mSemesters;
    private BaseInterface mBaseInterface;
    private ToolbarInterface mToolbarInterface;

    public static FinishSemesterFragment newInstance() { return new FinishSemesterFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mBaseInterface = (BaseInterface) getActivity();
        mToolbarInterface = (ToolbarInterface) getActivity();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_finish_semester, parent, false);
        ButterKnife.bind(this, view);
        initializeViews();
        toggleLayout();
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

    private void initializeViews() {
        mToolbarInterface.setTitle("Finish Semester");

        HashMap<String, String> queryParams = new HashMap<>();
        queryParams.put("current_semester", "true");
        Requests.Semesters.with(getActivity()).makeListRequest(queryParams);
    }

    private void toggleLayout() {
        mLayout.setVisibility(View.GONE);

        if (mSemesters == null) return;

        if (mSemesters.size() == 1) {
            mLayout.setVisibility(View.VISIBLE);
        }

    }

    @OnClick(R.id.finish_semester_continue)
    public void onContinueClick() {
        if (mEmail.getText().toString().equals(mBaseInterface.getUser().getEmail())) {
            openConfirmDialog();
        } else {
            mEmail.setError("Email must match your email");
        }
    }

    private void openConfirmDialog() {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity())
                .setTitle(R.string.semester_finish_confirm_title)
                .setMessage(R.string.semester_finish_confirm_message)
                .setPositiveButton(R.string.continue_confirm,
                        new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                makeFinishRequest();
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

    private void makeFinishRequest() {
        Semester currentSemester = mSemesters.get(0);
        currentSemester.setFinish(DateTime.now().toDate());
        Requests.Semesters.with(getActivity()).makeFinishRequest(currentSemester);
    }

    public void onEvent(FinishSemesterEvent event) {
        getActivity().setResult(Activity.RESULT_OK);
        getActivity().onBackPressed();
    }

    public void onEvent(SemesterListEvent event) {
        mSemesters = event.getSemesters();
        toggleLayout();
    }
}
