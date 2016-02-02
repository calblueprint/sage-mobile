package blueprint.com.sage.shared.activities;

import android.os.Bundle;

import blueprint.com.sage.R;
import blueprint.com.sage.shared.interfaces.ToolbarInterface;
import blueprint.com.sage.utility.view.ViewUtils;

/**
 * Created by charlesx on 2/1/16.
 */
public class EmptyAbstractActivity extends AbstractActivity implements ToolbarInterface {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_empty);
    }

    @Override
    public void setToolbarElevation(float i) {
        ViewUtils.setToolBarElevation(this, i);
    }
}
