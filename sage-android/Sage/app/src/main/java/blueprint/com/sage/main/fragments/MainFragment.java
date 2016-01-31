package blueprint.com.sage.main.fragments;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import blueprint.com.sage.R;
import blueprint.com.sage.shared.adapters.pagers.IconPagerAdapter;
import blueprint.com.sage.shared.interfaces.BaseInterface;
import blueprint.com.sage.utility.PermissionsUtils;
import blueprint.com.sage.utility.view.FragUtils;
import blueprint.com.sage.utility.view.ViewUtils;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 12/23/15.
 */
public class MainFragment extends Fragment {

    @Bind(R.id.tab_view) TabLayout mTabLayout;
    @Bind(R.id.view_pager) ViewPager mViewPager;

    private IconPagerAdapter mAdapter;
    private BaseInterface mBaseInterface;

    private float mMinAlpha;
    private float mMinElevation;

    public static MainFragment newInstance() { return new MainFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mBaseInterface = (BaseInterface) getActivity();

        TypedValue value = new TypedValue();
        getResources().getValue(R.dimen.tabs_alpha, value, true);
        mMinAlpha = value.getFloat();
        mMinElevation = getResources().getDimensionPixelSize(R.dimen.tab_layout_elevation);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_main, parent, false);
        ButterKnife.bind(this, view);
        initializeViews();
        return view;
    }

    public void initializeViews() {
        mAdapter = new IconPagerAdapter(getChildFragmentManager(), getActivity());

        mAdapter.addFragment(CheckInMapFragment.newInstance(), R.drawable.ic_place_white_24dp);
        mAdapter.addFragment(AnnouncementsListFragment.newInstance(), R.drawable.ic_announcement_white_24dp);

        if (mBaseInterface.getUser().isAdmin() || mBaseInterface.getUser().isPresident()) {
            mAdapter.addFragment(AdminPanelFragment.newInstance(), R.drawable.ic_assignment_white_24dp);
        }

        mAdapter.addFragment(UserFragment.newInstance(mBaseInterface.getUser()), R.drawable.ic_account_circle_white_24dp);

        mViewPager.setAdapter(mAdapter);
        mTabLayout.setupWithViewPager(mViewPager);
        mTabLayout.setSelectedTabIndicatorHeight(0);

        for (int i = 0; i < mAdapter.getCount(); i++) {
            TabLayout.Tab tab = mTabLayout.getTabAt(i);
            if (tab != null) {
                tab.setCustomView(mAdapter.getTabView(i));
            }
        }

        mViewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
                float toAlpha = (1 - positionOffset) * (1 - mMinAlpha) + mMinAlpha;
                float fromAlpha = (1 - toAlpha) + mMinAlpha;

                mAdapter.getTabView(position).setImageAlpha(toAlpha);

                if (position + 1 < mAdapter.getCount()) {
                    mAdapter.getTabView(position + 1).setImageAlpha(fromAlpha);
                }

                if ((mAdapter.getItem(position) instanceof AdminPanelFragment && mBaseInterface.getUser().isAdmin()) ||
                        (mAdapter.getItem(position) instanceof AnnouncementsListFragment && mBaseInterface.getUser().isStudent())) {
                    ViewUtils.setElevation(mTabLayout, mMinElevation * (1 - positionOffset));
                }
            }

            @Override
            public void onPageSelected(int position) {
            }

            @Override
            public void onPageScrollStateChanged(int state) {
            }
        });
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (resultCode != Activity.RESULT_OK) {
            return;
        }

        switch(requestCode) {
            case FragUtils.START_SEMESTER_REQUEST_CODE:
                setSemester(data);
                break;
            case FragUtils.FINISH_SEMESTER_REQUEST_CODE:
                clearSemester(data);
                break;
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        switch (requestCode) {
            case PermissionsUtils.PERMISSION_REQUEST_CODE: {
                if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    setUpMap();
                }
            }
        }
    }

    private void setSemester(Intent data) {
        for (Fragment fragment : getChildFragmentManager().getFragments()) {
            if (!(fragment instanceof AdminPanelFragment)) continue;

            AdminPanelFragment adminPanelFragment = (AdminPanelFragment) fragment;
            adminPanelFragment.onStartSemeseter(data);
        }
    }

    private void clearSemester(Intent data) {
        for (Fragment fragment : getChildFragmentManager().getFragments()) {
            if (!(fragment instanceof AdminPanelFragment)) continue;

            AdminPanelFragment adminPanelFragment = (AdminPanelFragment) fragment;
            adminPanelFragment.onFinishSemester(data);
        }
    }

    private void setUpMap() {
        for (Fragment fragment : getChildFragmentManager().getFragments()) {
            if (!(fragment instanceof CheckInMapFragment)) continue;

            CheckInMapFragment checkInMapFragment = (CheckInMapFragment) fragment;
            checkInMapFragment.setUpMap();
        }
    }
}

