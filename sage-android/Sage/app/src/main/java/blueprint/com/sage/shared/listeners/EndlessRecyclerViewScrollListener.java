package blueprint.com.sage.shared.listeners;

import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;

/**
 * Created by charlesx on 2/27/16.
 */
public abstract class EndlessRecyclerViewScrollListener extends RecyclerView.OnScrollListener {

    private int mVisibleThreshold = 5;
    private int mCurrentPage = 0;
    private int mPreviousItemCount = 0;
    private boolean mLoading = true;
    private int mStartingPageIndex = 0;

    private LinearLayoutManager mLinearLayoutManager;

    public EndlessRecyclerViewScrollListener(LinearLayoutManager manager) {
        mLinearLayoutManager = manager;
    }

    @Override
    public void onScrolled(RecyclerView view, int dx, int dy) {
        int firstVisibleItem = mLinearLayoutManager.findFirstVisibleItemPosition();
        int visibleItemCount = view.getChildCount();
        int totalItemCount = mLinearLayoutManager.getItemCount();

        if (totalItemCount < mPreviousItemCount) {
            mCurrentPage = mStartingPageIndex;
            mPreviousItemCount = totalItemCount;
            if (totalItemCount == 0) {
                mLoading = true;
            }
        }

        if (mLoading && (totalItemCount > mPreviousItemCount)) {
            mLoading = false;
            mPreviousItemCount = totalItemCount;
        }

        if (!mLoading && (totalItemCount - visibleItemCount) <= (firstVisibleItem + mVisibleThreshold)) {
            mCurrentPage++;
            onLoadMore(mCurrentPage, totalItemCount);
            mLoading = true;
        }
    }

    public abstract void onLoadMore(int currentPage, int totalItemCount);
}
