package blueprint.com.sage.browse.fragments;

import blueprint.com.sage.shared.adapters.PagerAdapter;
import blueprint.com.sage.shared.fragments.TabsFragment;

/**
 * Created by charlesx on 11/17/15.
 */
public class BrowseTabFragment extends TabsFragment {

    private PagerAdapter mAdapter;

    public static BrowseTabFragment newInstance() { return new BrowseTabFragment(); }

    public void initializeViews() {
        mAdapter = new PagerAdapter(getChildFragmentManager());

        mAdapter.addFragment(SchoolListFragment.newInstance(), "Schools");
        mAdapter.addFragment(UserListFragment.newInstance(), "Users");

        mViewPager.setAdapter(mAdapter);
        mTabLayout.setupWithViewPager(mViewPager);
    }
}
