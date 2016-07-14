package blueprint.com.sage.utility.model;

import android.app.Activity;
import android.graphics.drawable.GradientDrawable;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import blueprint.com.sage.R;
import blueprint.com.sage.models.User;

/**
 * Created by kelseylam on 2/16/16.
 */
public class UserUtils {
    public static void setTypeBackground(Activity activity, User user, TextView userType, ImageView border, String[] roles) {
        int role = user.getRole();
        if (user.getDirectorId() != 0) {
            role = 3;
        }
        GradientDrawable shape = (GradientDrawable) userType.getBackground();
        userType.setVisibility(View.VISIBLE);
        if (border != null) {
            border.setVisibility(View.VISIBLE);
        }
        userType.setText(roles[role]);
        switch(role) {
            case 0:
                userType.setVisibility(View.GONE);
                if (border != null) {
                    border.setVisibility(View.GONE);
                }
                break;
            case 1:
                shape.setColor(activity.getResources().getColor(R.color.orange_admin));
                break;
            case 2:
                shape.setColor(activity.getResources().getColor(R.color.blue_president));
                break;
            case 3:
                shape.setColor(activity.getResources().getColor(R.color.turquoise_director));
                break;
        }
    }
}
