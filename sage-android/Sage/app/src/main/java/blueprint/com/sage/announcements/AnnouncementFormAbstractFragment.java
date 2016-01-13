package blueprint.com.sage.announcements;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.Spinner;

import java.util.ArrayList;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.events.schools.SchoolListEvent;
import blueprint.com.sage.models.Announcement;
import blueprint.com.sage.models.School;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.adapters.SchoolSpinnerAdapter;
import blueprint.com.sage.shared.validators.FormValidator;
import butterknife.Bind;
import butterknife.ButterKnife;
import de.greenrobot.event.EventBus;

/**
 * Created by kelseylam on 1/13/16.
 */
public abstract class AnnouncementFormAbstractFragment extends Fragment {

    @Bind(R.id.create_announcement_layout) View mCreateAnnouncement;
    @Bind(R.id.create_announcement_title) EditText mAnnouncementTitle;
    @Bind(R.id.create_announcement_body) EditText mAnnouncementBody;
    @Bind(R.id.announcement_category) Spinner mAnnouncementCategory;
    @Bind(R.id.announcement_school_list) Spinner mAnnouncementSchoolList;

    protected Announcement mAnnouncement;
    protected List<School> mSchools;
    private FormValidator mValidator;
    protected SchoolSpinnerAdapter mSchoolAdapter;

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
    public void onStart() {
        super.onStart();
        EventBus.getDefault().register(this);
    }

    @Override
    public void onStop() {
        super.onStop();
        EventBus.getDefault().unregister(this);
    }

    protected boolean isValid() {
        return mValidator.hasNonBlankField(mAnnouncementTitle, "Title") &
                mValidator.hasNonBlankField(mAnnouncementBody, "Body") &
                (mAnnouncement.getCategory() == 0 && mSchoolAdapter.getCount() != 0);
    }

    protected abstract boolean validateAndSubmitRequest();

    public void onEvent(SchoolListEvent event) {
        mSchools = event.getSchools();
        if (mSchoolAdapter != null) { mSchoolAdapter.setSchools(mSchools);}
    }

    public abstract void initializeViews();

    public void initializeSpinners() {
        final ArrayAdapter<CharSequence> categoryAdapter = ArrayAdapter.createFromResource(getActivity(), R.array.categories, android.R.layout.simple_spinner_item);
        categoryAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        mAnnouncementCategory.setAdapter(categoryAdapter);
        mSchoolAdapter = new SchoolSpinnerAdapter(getActivity(), mSchools, R.layout.simple_spinner_item, R.layout.simple_spinner_item);
        mSchoolAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        mAnnouncementSchoolList.setAdapter(mSchoolAdapter);

        mAnnouncementCategory.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                if (mAnnouncementCategory.getSelectedItem().equals("General Announcement")) {
                    mAnnouncementSchoolList.setVisibility(View.GONE);
                } else if (mAnnouncementCategory.getSelectedItem().equals("School Announcement")) {
                    mAnnouncementSchoolList.setVisibility(View.VISIBLE);
                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {}
        });
    }

    public void setAnnouncement() {
        if (mAnnouncementCategory.getSelectedItem().equals("General Announcement")) {
            mAnnouncement.setCategory(1);
            mAnnouncement.setSchoolId(0);
        } else if (mAnnouncementCategory.getSelectedItem().equals("School Announcement")) {
            mAnnouncement.setCategory(0);
            School school = (School) mAnnouncementSchoolList.getSelectedItem();
            mAnnouncement.setSchoolId(school.getId());
        }
    }

    public void setSchoolSpinner() {
        School school = mAnnouncement.getSchool();
        for (int i = 0; i < mSchools.size(); i++) {
            if (mSchools.get(i).getId() == school.getId()) {
                mAnnouncementSchoolList.setSelection(i);
            }
        }
    }
}
