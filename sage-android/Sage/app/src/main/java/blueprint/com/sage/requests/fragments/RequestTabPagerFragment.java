package blueprint.com.sage.requests.fragments;

import blueprint.com.sage.R;
import blueprint.com.sage.shared.adapters.PagerAdapter;
import blueprint.com.sage.shared.fragments.TabsFragment;

/**
 * Created by charlesx on 11/14/15.
 */
public class RequestTabPagerFragment extends TabsFragment {

    private PagerAdapter mPagerAdapter;

    public static RequestTabPagerFragment newInstance() { return new RequestTabPagerFragment();}

    public void initializeViews() {
        mPagerAdapter = new PagerAdapter(getChildFragmentManager());

        mPagerAdapter.addFragment(UnverifiedCheckInListFragment.newInstance(), getString(R.string.requests_check_in));
        mPagerAdapter.addFragment(UnverifiedUsersListFragment.newInstance(), getString(R.string.requests_users));

        mViewPager.setAdapter(mPagerAdapter);
        mTabLayout.setupWithViewPager(mViewPager);
    }
}
