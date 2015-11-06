package blueprint.com.sage.shared.views;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.util.AttributeSet;
import android.view.View;

/**
 * Created by charlesx on 11/5/15.
 * A empty recycleview
 */
public class RecycleViewEmpty extends RecyclerView {

    private AdapterDataObserver mObserver;

    private int mEmptyViewId;
    private View mEmptyView;

    public RecycleViewEmpty(Context context) {
        super(context);
        initView();
    }

    public RecycleViewEmpty(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
        initView();
    }

    public RecycleViewEmpty(Context context, AttributeSet attributeSet, int defStyleAttr) {
        super(context, attributeSet, defStyleAttr);
        initView();
    }

    @Override
    public void setAdapter(Adapter adapter) {
        super.setAdapter(adapter);

        Adapter oldAdapter = getAdapter();

        if (oldAdapter != null)
            oldAdapter.unregisterAdapterDataObserver(mObserver);

        if (adapter != null)
            adapter.registerAdapterDataObserver(mObserver);

        refreshLayout();
    }

    private void initView() {
        mObserver = new AdapterDataObserver() {
            @Override
            public void onChanged() {
                super.onChanged();
                refreshLayout();
            }

            @Override
            public void onItemRangeInserted(int positionStart, int itemCount) {
                super.onItemRangeInserted(positionStart, itemCount);
                refreshLayout();
            }

            @Override
            public void onItemRangeRemoved(int positionStart, int itemCount) {
                super.onItemRangeRemoved(positionStart, itemCount);
                refreshLayout();
            }
        };
    }

    private void setEmptyView(View view) {
        mEmptyView = view;
    }

    private void refreshLayout() {
        Adapter adapter = getAdapter();

        if (mEmptyView == null)
            toggleRecyclerView(true);

        if (adapter == null) {
            showRecyclerView();
        } else {
            toggleRecyclerView(adapter.getItemCount() > 0);
        }

    }

    private void toggleRecyclerView(boolean showRecyclerView) {
        if (showRecyclerView) {
            showRecyclerView();
        } else {
            showEmptyView();
        }
    }

    private void showRecyclerView() {
        setVisibility(View.VISIBLE);

        if (mEmptyView != null)
            setVisibility(View.GONE);
    }

    private void showEmptyView() {
        if (mEmptyView == null)
            return;

        setVisibility(View.GONE);
        mEmptyView.setVisibility(View.VISIBLE);
    }
}
