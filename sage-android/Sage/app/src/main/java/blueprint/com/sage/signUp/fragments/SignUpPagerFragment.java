package blueprint.com.sage.signUp.fragments;

import android.annotation.TargetApi;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import blueprint.com.sage.R;
import blueprint.com.sage.signUp.SignUpActivity;
import blueprint.com.sage.signUp.adapters.SignUpPagerAdapter;
import blueprint.com.sage.signUp.animation.SignUpPageTransformer;
import blueprint.com.sage.signUp.events.BackEvent;
import blueprint.com.sage.signUp.events.PhotoEvent;
import butterknife.Bind;
import butterknife.ButterKnife;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 10/12/15.
 * Fragment that contains the viewpager
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

    private void setUpViews(View view) {
        mViewPagerAdapter = new SignUpPagerAdapter(getChildFragmentManager());

        mViewPagerAdapter.addFragment(SignUpNameFragment.newInstance(), getString(R.string.sign_up_name));
        mViewPagerAdapter.addFragment(SignUpEmailFragment.newInstance(), getString(R.string.sign_up_email));
        mViewPagerAdapter.addFragment(SignUpSchoolFragment.newInstance(), getString(R.string.sign_up_school));
        mViewPagerAdapter.addFragment(SignUpProfileFragment.newInstance(), getString(R.string.sign_up_profile));

        mViewPager.setAdapter(mViewPagerAdapter);
        mViewPager.setPageTransformer(true, new SignUpPageTransformer());
    }

    public void onEvent(PhotoEvent event) {
        Log.w("Got here", "wtatwatawat");
        if (event == null) return;
    }

    public void onEvent(BackEvent event) {
        if (mViewPager.getCurrentItem() == 0) {
            SignUpActivity activity = (SignUpActivity) getActivity();
            activity.finish();
        } else {
            mViewPager.setCurrentItem(mViewPager.getCurrentItem() - 1, true);
        }
    }

    public void goToNextPage() {
        if (mViewPager.getCurrentItem() == mViewPagerAdapter.getCount() - 1) {
        } else {
            mViewPager.setCurrentItem(mViewPager.getCurrentItem() + 1, true);
        }
    }

    @SuppressWarnings("deprecation")
    @TargetApi(16)
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (resultCode != SignUpActivity.RESULT_OK) return;

        switch (requestCode) {
            case SignUpProfileFragment.CAMERA_REQUEST:
                handleTakePhotoResult(data);
                break;
            case SignUpProfileFragment.PICK_PHOTO_REQUEST:
                handlePickPhotoResult(data);
                break;
        }
    }

    private void handlePickPhotoResult(Intent data) {
        for (Fragment fragment : getChildFragmentManager().getFragments()) {
            if (!(fragment instanceof SignUpProfileFragment)) continue;

            SignUpProfileFragment profFragment = (SignUpProfileFragment) fragment;
            profFragment.pickPhotoResult(data);
        }
    }

    private void handleTakePhotoResult(Intent data) {
        if (getChildFragmentManager().getFragments() == null) return;
        for (Fragment fragment : getChildFragmentManager().getFragments()) {
            if (!(fragment instanceof SignUpProfileFragment)) continue;

            SignUpProfileFragment profFragment = (SignUpProfileFragment) fragment;
            profFragment.takePhotoResult(data);
        }
    }
}
