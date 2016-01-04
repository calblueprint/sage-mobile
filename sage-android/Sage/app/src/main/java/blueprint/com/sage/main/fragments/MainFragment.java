package blueprint.com.sage.main.fragments;

import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import blueprint.com.sage.R;
import blueprint.com.sage.shared.adapters.IconPagerAdapter;
import blueprint.com.sage.shared.interfaces.BaseInterface;
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

        if (mBaseInterface.getUser().isAdmin())
            mAdapter.addFragment(AdminPanelFragment.newInstance(), R.drawable.ic_assignment_white_24dp);

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

                if (mAdapter.getItem(position) instanceof AdminPanelFragment) {
                    ViewUtils.setElevation(mTabLayout, mMinElevation * (1 - positionOffset));
                }
            }

            @Override
            public void onPageSelected(int position) {}

            @Override
            public void onPageScrollStateChanged(int state) {}
        });
    }
}
