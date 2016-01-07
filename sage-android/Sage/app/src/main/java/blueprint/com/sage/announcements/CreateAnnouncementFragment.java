package blueprint.com.sage.announcements;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.Spinner;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.events.announcements.CreateAnnouncementEvent;
import blueprint.com.sage.events.schools.SchoolListEvent;
import blueprint.com.sage.models.Announcement;
import blueprint.com.sage.models.School;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.adapters.SchoolSpinnerAdapter;
import blueprint.com.sage.shared.interfaces.BaseInterface;
import blueprint.com.sage.shared.validators.FormValidator;
import blueprint.com.sage.utility.view.FragUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import de.greenrobot.event.EventBus;

/**
 * Created by kelseylam on 12/5/15.
 */
public class CreateAnnouncementFragment extends Fragment {

    @Bind(R.id.create_announcement_layout) View mCreateAnnouncement;
    @Bind(R.id.create_announcement_title) EditText mAnnouncementTitle;
    @Bind(R.id.create_announcement_body) EditText mAnnouncementBody;
    @Bind(R.id.announcement_category) Spinner mAnnouncementCategory;
    @Bind(R.id.announcement_school_list) Spinner mAnnouncementSchoolList;

    private Announcement mAnnouncement;
    private List<School> mSchools = new ArrayList<>();
    private SchoolSpinnerAdapter mSchoolAdapter;
    private User mUser;
    private FormValidator mValidator;

    public static CreateAnnouncementFragment newInstance() { return new CreateAnnouncementFragment(); }

    public void initializeAnnouncement() {
        getActivity().setTitle("Create Announcement");
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mValidator = FormValidator.newInstance(getActivity());
        Requests.Schools.with(getActivity()).makeListRequest(new HashMap<String, String>());
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_create_announcement, parent, false);
        ButterKnife.bind(this, view);
        createAnnouncement();
        initializeSpinners();
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

    private void initializeSpinners() {
        initializeAnnouncement();
        final ArrayAdapter<CharSequence> categoryAdapter = ArrayAdapter.createFromResource(getActivity(), R.array.categories, android.R.layout.simple_spinner_item);
        categoryAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        mAnnouncementCategory.setAdapter(categoryAdapter);
        mAnnouncementCategory.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                if (mAnnouncementCategory.getSelectedItem().equals("General Announcement")) {
                    mAnnouncement.setCategory("0");
                    mAnnouncementSchoolList.setVisibility(View.GONE);
                } else if (mAnnouncementCategory.getSelectedItem().equals("School Announcement")) {
                    mAnnouncement.setCategory("1");
                    mAnnouncementSchoolList.setVisibility(View.VISIBLE);
                    mSchoolAdapter = new SchoolSpinnerAdapter(getActivity(), mSchools, R.layout.simple_spinner_item, R.layout.simple_spinner_item);
                    mSchoolAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
                    mAnnouncementSchoolList.setAdapter(mSchoolAdapter);
                    mAnnouncementSchoolList.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
                        @Override
                        public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                            School school = (School) adapterView.getSelectedItem();
                            mAnnouncement.setSchoolId(school.getId());
                            BaseInterface baseInterface = (BaseInterface) getActivity();
                            mUser = baseInterface.getUser();
                            mAnnouncement.setUserId(mUser.getId());
                        }

                        @Override
                        public void onNothingSelected(AdapterView<?> adapterView) {
                            School school = (School) adapterView.getSelectedItem();
                            mAnnouncement.setSchoolId(school.getId());
                            BaseInterface baseInterface = (BaseInterface) getActivity();
                            mUser = baseInterface.getUser();
                            mAnnouncement.setUserId(mUser.getId());
                        }
                    });
                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {
                mAnnouncement.setCategory("0");
            }
        });
    }

    private void createAnnouncement() {
        mAnnouncement = new Announcement();
        mAnnouncement.setTitle(mAnnouncementTitle.getText().toString());
        mAnnouncement.setBody(mAnnouncementBody.getText().toString());
    }

    private boolean isValid() {
        return mValidator.hasNonBlankField(mAnnouncementTitle, "Title") &
                mValidator.hasNonBlankField(mAnnouncementBody, "Body");
    }

    private void validateAndSubmitRequest() {
        if (!isValid())
            return;
        Requests.Announcements.with(getActivity()).makeCreateRequest(mAnnouncement);
    }

    public void onEvent(CreateAnnouncementEvent event) {
        FragUtils.popBackStack(this);
    }

    public void onEvent(SchoolListEvent event) {
        mSchools = event.getSchools();
//        mSchoolAdapter.setSchools(mSchools);
    }

}
