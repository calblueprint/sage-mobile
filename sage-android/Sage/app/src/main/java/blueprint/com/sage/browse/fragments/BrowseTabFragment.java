package blueprint.com.sage.browse.fragments;

import android.os.Bundle;

import blueprint.com.sage.shared.adapters.PagerAdapter;
import blueprint.com.sage.shared.fragments.TabsFragment;
import blueprint.com.sage.shared.interfaces.NavigationInterface;

/**
 * Created by charlesx on 11/17/15.
 */
public class BrowseTabFragment extends TabsFragment {

    private PagerAdapter mAdapter;

    private NavigationInterface mNavigationInterface;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mNavigationInterface = (NavigationInterface) getActivity();
    }

    public static BrowseTabFragment newInstance() { return new BrowseTabFragment(); }

    public void initializeViews() {
        mAdapter = new PagerAdapter(getChildFragmentManager());

        mAdapter.addFragment(SchoolListFragment.newInstance(), "Schools");
        mAdapter.addFragment(UserListFragment.newInstance(), "Users");

        mViewPager.setAdapter(mAdapter);
        mTabLayout.setupWithViewPager(mViewPager);

        mNavigationInterface.toggleDrawerUse(true);
        getActivity().setTitle("Browse");
    }
}
