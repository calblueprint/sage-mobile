package blueprint.com.sage.shared.fragments;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;

import blueprint.com.sage.R;
import blueprint.com.sage.shared.interfaces.ListDialogInterface;
import lombok.Data;

/**
 * Created by charlesx on 1/4/16.
 * Shows a dialog where user can choose between a list of items
 */
public @Data class ListDialog extends DialogFragment {

    private ListDialogInterface listInterface;
    private int list;
    private int title;

    public static ListDialog newInstance(ListDialogInterface listInterface, int title, int list) {
        ListDialog dialog = new ListDialog();
        dialog.setListInterface(listInterface);
        dialog.setList(list);
        dialog.setTitle(title);
        return dialog;
    }

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());

        final String[] roles = getResources().getStringArray(R.array.user_promote_options);

        builder.setTitle(title).setItems(roles,
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        listInterface.selectedItem(i, getTargetRequestCode());
                        dialogInterface.dismiss();
                    }
                }).setNegativeButton(R.string.cancel,
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        dialogInterface.dismiss();
                    }
                });

        return builder.show();
    }
}
