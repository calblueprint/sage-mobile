package blueprint.com.sage.sign_up.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import blueprint.com.sage.R;
import blueprint.com.sage.sign_up.SignUpPagerAdapter;
import blueprint.com.sage.sign_up.animation.SignUpPageTransformer;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 10/12/15.
 */
public class SignUpPagerFragment extends Fragment {

    @Bind(R.id.sign_up_view_pager) ViewPager mViewPager;

    private SignUpPagerAdapter mViewPagerAdapter;

    public static SignUpPagerFragment newInstance() { return new SignUpPagerFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_sign_up_pager, parent, false);
        ButterKnife.bind(this, view);
        setUpViews(view);
        return view;
    }

    private void setUpViews(View view) {
        mViewPagerAdapter = new SignUpPagerAdapter(getChildFragmentManager());

        mViewPagerAdapter.addFragment(SignUpNameFragment.newInstance(), getString(R.string.sign_up_name));
        mViewPagerAdapter.addFragment(SignUpEmailFragment.newInstance(), getString(R.string.sign_up_email));
        mViewPagerAdapter.addFragment(SignUpSchoolFragment.newInstance(), getString(R.string.sign_up_school));
        mViewPagerAdapter.addFragment(SignUpProfileFragment.newInstance(), getString(R.string.sign_up_profile));

        mViewPager.setAdapter(mViewPagerAdapter);
        mViewPager.setPageTransformer(true, new SignUpPageTransformer());
    }
}
