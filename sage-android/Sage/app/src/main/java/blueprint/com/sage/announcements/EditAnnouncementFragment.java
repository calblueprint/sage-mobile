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
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.events.announcements.EditAnnouncementEvent;
import blueprint.com.sage.events.schools.SchoolListEvent;
import blueprint.com.sage.models.Announcement;
import blueprint.com.sage.models.School;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.adapters.SchoolSpinnerAdapter;
import blueprint.com.sage.shared.validators.FormValidator;
import blueprint.com.sage.utility.view.FragUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import de.greenrobot.event.EventBus;

/**
 * Created by kelseylam on 1/7/16.
 */
public class EditAnnouncementFragment extends Fragment {

    @Bind(R.id.create_announcement_layout) View mCreateAnnouncement;
    @Bind(R.id.create_announcement_title) EditText mAnnouncementTitle;
    @Bind(R.id.create_announcement_body) EditText mAnnouncementBody;
    @Bind(R.id.announcement_category) Spinner mAnnouncementCategory;
    @Bind(R.id.announcement_school_list) Spinner mAnnouncementSchoolList;

    private Announcement mAnnouncement;
    private List<School> mSchools;
    private FormValidator mValidator;
    private SchoolSpinnerAdapter mSchoolAdapter;

    public static EditAnnouncementFragment newInstance(Announcement announcement) {
        EditAnnouncementFragment fragment = new EditAnnouncementFragment();
        fragment.setAnnouncement(announcement);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mSchools = new ArrayList<>();
        mValidator = FormValidator.newInstance(getActivity());
        Requests.Schools.with(getActivity()).makeListRequest(null);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_create_announcement, parent, false);
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
                makeRequest();
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    public void setAnnouncement(Announcement announcement) { mAnnouncement = announcement; }

    public void initializeViews() {
        getActivity().setTitle("Edit Announcement");
        mAnnouncementTitle.setText(mAnnouncement.getTitle());
        mAnnouncementBody.setText(mAnnouncement.getBody());
        setSpinners();
    }

    public void setSpinners() {
        final ArrayAdapter<CharSequence> categoryAdapter = ArrayAdapter.createFromResource(getActivity(), R.array.categories, android.R.layout.simple_spinner_item);
        categoryAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        mAnnouncementCategory.setAdapter(categoryAdapter);
        mSchoolAdapter = new SchoolSpinnerAdapter(getActivity(), mSchools, R.layout.simple_spinner_item, R.layout.simple_spinner_item);
        mSchoolAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        mAnnouncementSchoolList.setAdapter(mSchoolAdapter);
        int category = mAnnouncement.getCategory();
        if (category == 0) {
            mAnnouncementCategory.setSelection(1);
            mAnnouncementSchoolList.setVisibility(View.VISIBLE);
            School school = mAnnouncement.getSchool();
            for (int i = 0; i < mSchools.size(); i++) {
                if (mSchools.get(i).getId() == school.getId()) {
                    mAnnouncementSchoolList.setSelection(i);
                }
            }
        } else {
            mAnnouncementCategory.setSelection(0);
        }
        setSpinnerListeners();
    }

    private boolean isValid() {
        return mValidator.hasNonBlankField(mAnnouncementTitle, "Title") &
                mValidator.hasNonBlankField(mAnnouncementBody, "Body");
    }

    public void makeRequest() {
        if (!isValid())
            return;
        mAnnouncement.setTitle(mAnnouncementTitle.getText().toString());
        mAnnouncement.setBody(mAnnouncementBody.getText().toString());
        Requests.Announcements.with(getActivity()).makeEditRequest(mAnnouncement);

    }

    public void setSpinnerListeners() {
        mAnnouncementCategory.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                if (mAnnouncementCategory.getSelectedItem().equals("General Announcement")) {
                    mAnnouncement.setCategory(1);
                    mAnnouncement.setSchoolId(0);
                    mAnnouncement.setSchoolName(null);
                    mAnnouncementSchoolList.setVisibility(View.GONE);
                } else if (mAnnouncementCategory.getSelectedItem().equals("School Announcement")) {
                    mAnnouncement.setCategory(0);
                    mAnnouncementSchoolList.setVisibility(View.VISIBLE);
                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {
            }
        });
        mAnnouncementSchoolList.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                School school = (School) adapterView.getSelectedItem();
                mAnnouncement.setSchoolId(school.getId());
                mAnnouncement.setSchoolName(school.getName());
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {
            }
        });
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

    public void onEvent(EditAnnouncementEvent event) {
        FragUtils.popBackStack(this);
    }

    public void onEvent(SchoolListEvent event) {
        mSchools = event.getSchools();
        if (mSchoolAdapter != null) { mSchoolAdapter.setSchools(mSchools);}
    }
}
