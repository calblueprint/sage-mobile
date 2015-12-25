package blueprint.com.sage.browse.fragments;

import android.os.Bundle;

import blueprint.com.sage.shared.adapters.SimplePagerAdapter;
import blueprint.com.sage.shared.fragments.TabsFragment;

/**
 * Created by charlesx on 11/17/15.
 */
public class BrowseTabFragment extends TabsFragment {

    private SimplePagerAdapter mAdapter;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    public static BrowseTabFragment newInstance() { return new BrowseTabFragment(); }

    public void initializeViews() {
        mAdapter = new SimplePagerAdapter(getChildFragmentManager());

        mAdapter.addFragment(SchoolListFragment.newInstance(), "Schools");
        mAdapter.addFragment(UserListFragment.newInstance(), "Users");

        mViewPager.setAdapter(mAdapter);
        mTabLayout.setupWithViewPager(mViewPager);

        getActivity().setTitle("Browse");
    }
}
