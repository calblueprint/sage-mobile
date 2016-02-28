package blueprint.com.sage.shared.listeners;

import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;

import blueprint.com.sage.shared.PaginationInstance;

/**
 * Created by charlesx on 2/27/16.
 */
public abstract class EndlessRecyclerViewScrollListener extends RecyclerView.OnScrollListener {

    private int mVisibleThreshold = 5;
    private int mPreviousItemCount = 0;
    private boolean mLoading = true;

    private LinearLayoutManager mLinearLayoutManager;
    private PaginationInstance mPaginationInstance;

    public EndlessRecyclerViewScrollListener(LinearLayoutManager manager, PaginationInstance paginationInstance) {
        mLinearLayoutManager = manager;
        mPaginationInstance = paginationInstance;
    }

    @Override
    public void onScrolled(RecyclerView view, int dx, int dy) {
        int firstVisibleItem = mLinearLayoutManager.findFirstVisibleItemPosition();
        int visibleItemCount = view.getChildCount();
        int totalItemCount = mLinearLayoutManager.getItemCount();

        if (totalItemCount < mPreviousItemCount) {
            mPreviousItemCount = totalItemCount;
            mPaginationInstance.resetPage();
            if (totalItemCount == 0) {
                mLoading = true;
            }
        }

        if (mLoading && (totalItemCount > mPreviousItemCount)) {
            mLoading = false;
            mPreviousItemCount = totalItemCount;
        }

        if (!mLoading && (totalItemCount - visibleItemCount) <= (firstVisibleItem + mVisibleThreshold)) {
            mLoading = true;
            onLoadMore();
        }
    }

    public abstract void onLoadMore();
}
