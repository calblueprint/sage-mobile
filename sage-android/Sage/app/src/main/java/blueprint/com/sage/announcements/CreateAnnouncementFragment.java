package blueprint.com.sage.announcements;

import android.view.MenuItem;

import blueprint.com.sage.R;
import blueprint.com.sage.events.announcements.CreateAnnouncementEvent;
import blueprint.com.sage.models.Announcement;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.interfaces.BaseInterface;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by kelseylam on 12/5/15.
 */
public class CreateAnnouncementFragment extends AnnouncementFormAbstractFragment {

//    @Bind(R.id.create_announcement_layout) View mCreateAnnouncement;
//    @Bind(R.id.create_announcement_title) EditText mAnnouncementTitle;
//    @Bind(R.id.create_announcement_body) EditText mAnnouncementBody;
//    @Bind(R.id.announcement_category) Spinner mAnnouncementCategory;
//    @Bind(R.id.announcement_school_list) Spinner mAnnouncementSchoolList;
//
//    private Announcement mAnnouncement;
//    private List<School> mSchools;
//    private SchoolSpinnerAdapter mSchoolAdapter;
//    private FormValidator mValidator;

    public static CreateAnnouncementFragment newInstance() { return new CreateAnnouncementFragment(); }

//    @Override
//    public void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setHasOptionsMenu(true);
//        mValidator = FormValidator.newInstance(getActivity());
//        mBaseInterface = (BaseInterface) getActivity();
//        mAnnouncement = new Announcement();
//        Requests.Schools.with(getActivity()).makeListRequest(null);
//    }
//
//    @Override
//    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
//        super.onCreateView(inflater, parent, savedInstanceState);
//        View view = inflater.inflate(R.layout.fragment_create_announcement, parent, false);
//        ButterKnife.bind(this, view);
//        initializeSpinners();
//        return view;
//    }

//    @Override
//    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
//        menu.clear();
//        inflater.inflate(R.menu.menu_save, menu);
//        super.onCreateOptionsMenu(menu, inflater);
//    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.menu_save:
                if (validateAndSubmitRequest()) getActivity().onBackPressed();
            default:
                return super.onOptionsItemSelected(item);
        }
    }

//    @Override
//    public void onStart() {
//        super.onStart();
//        EventBus.getDefault().register(this);
//    }
//
//    @Override
//    public void onStop() {
//        super.onStop();
//        EventBus.getDefault().unregister(this);
//    }

//    private void initializeSpinners() {
//        initializeAnnouncement();
//        final ArrayAdapter<CharSequence> categoryAdapter = ArrayAdapter.createFromResource(getActivity(), R.array.categories, android.R.layout.simple_spinner_item);
//        categoryAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
//        mAnnouncementCategory.setAdapter(categoryAdapter);
//        mAnnouncementCategory.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
//            @Override
//            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
//                if (mAnnouncementCategory.getSelectedItem().equals("General Announcement")) {
//                    mAnnouncement.setCategory(1);
//                    mAnnouncement.setUserId(mBaseInterface.getUser().getId());
//                    mAnnouncement.setUserName(mBaseInterface.getUser().getName());
//                    mAnnouncement.setSchoolId(0);
//                    mAnnouncement.setSchoolName(null);
//                    mAnnouncementSchoolList.setVisibility(View.GONE);
//                } else if (mAnnouncementCategory.getSelectedItem().equals("School Announcement")) {
//                    mAnnouncement.setCategory(0);
//                    mAnnouncementSchoolList.setVisibility(View.VISIBLE);
//                    mSchoolAdapter = new SchoolSpinnerAdapter(getActivity(), mSchools, R.layout.simple_spinner_item, R.layout.simple_spinner_item);
//                    mSchoolAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
//                    mAnnouncementSchoolList.setAdapter(mSchoolAdapter);
//                    mAnnouncementSchoolList.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
//                        @Override
//                        public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
//                            School school = (School) adapterView.getSelectedItem();
//                            mAnnouncement.setSchoolId(school.getId());
//                            mAnnouncement.setSchoolName(school.getName());
//                            mAnnouncement.setUserId(mBaseInterface.getUser().getId());
//                            mAnnouncement.setUserName(mBaseInterface.getUser().getName());
//                        }
//
//                        @Override
//                        public void onNothingSelected(AdapterView<?> adapterView) {
//                        }
//                    });
//                }
//            }
//
//            @Override
//            public void onNothingSelected(AdapterView<?> adapterView) {
//            }
//        });
//    }

//    private boolean isValid() {
//        return mValidator.hasNonBlankField(mAnnouncementTitle, "Title") &
//                mValidator.hasNonBlankField(mAnnouncementBody, "Body") &
//                (mAnnouncement.getCategory() == 0 && mSchools.size() != 0);
//    }

//    private void validateAndSubmitRequest() {
//        if (!isValid())
//            return;
//        mAnnouncement.setTitle(mAnnouncementTitle.getText().toString());
//        mAnnouncement.setBody(mAnnouncementBody.getText().toString());
//        Requests.Announcements.with(getActivity()).makeCreateRequest(mAnnouncement);
//    }

    public void initializeViews() {
        getActivity().setTitle("Create Announcement");
        mAnnouncement = new Announcement();
        initializeSpinners();
    }

    private void setUser() {
        BaseInterface baseInterface = (BaseInterface) getActivity();
        mAnnouncement.setUserId(baseInterface.getUser().getId());
    }

    protected boolean validateAndSubmitRequest() {
        if (!isValid())
            return false;
        mAnnouncement.setTitle(mAnnouncementTitle.getText().toString());
        mAnnouncement.setBody(mAnnouncementBody.getText().toString());
        setAnnouncement();
        Requests.Announcements.with(getActivity()).makeCreateRequest(mAnnouncement);
        return true;
    }

    public void onEvent(CreateAnnouncementEvent event) {
        FragUtils.popBackStack(this);
    }

//    public void onEvent(SchoolListEvent event) {
//        mSchools = event.getSchools();
//        mSchoolAdapter.setSchools(mSchools);
//    }

}
