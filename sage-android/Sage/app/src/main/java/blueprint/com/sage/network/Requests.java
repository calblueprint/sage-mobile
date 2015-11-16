package blueprint.com.sage.network;

import android.app.Activity;
import android.content.Context;

import com.android.volley.Request;
import com.android.volley.Response;

import java.util.ArrayList;
import java.util.HashMap;

import blueprint.com.sage.events.checkIns.CheckInListEvent;
import blueprint.com.sage.events.checkIns.DeleteCheckInEvent;
import blueprint.com.sage.events.checkIns.VerifyCheckInEvent;
import blueprint.com.sage.events.users.DeleteUserEvent;
import blueprint.com.sage.events.users.UserListEvent;
import blueprint.com.sage.events.users.VerifyUserEvent;
import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.CheckIn;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.check_ins.CheckInListRequest;
import blueprint.com.sage.network.check_ins.DeleteCheckInRequest;
import blueprint.com.sage.network.check_ins.VerifyCheckInRequest;
import blueprint.com.sage.network.users.DeleteUserRequest;
import blueprint.com.sage.network.users.UserListRequest;
import blueprint.com.sage.network.users.VerifyUserRequest;
import blueprint.com.sage.utility.network.NetworkManager;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 11/15/15.
 */
public class Requests {

    public static void addToRequestQueue(Context context, Request request) {
        NetworkManager.getInstance(context).getRequestQueue().add(request);
    }

    public static class Users {

        private Activity mActivity;

        public Users(Activity activity) {
            mActivity = activity;
        }

        public static Users with(Activity activity) {
            return new Users(activity);
        }

        public void makeListRequest(HashMap<String, String> queryParams) {

            UserListRequest request = new UserListRequest(mActivity, queryParams,
                    new Response.Listener<ArrayList<User>>() {
                        @Override
                        public void onResponse(ArrayList<User> users) {
                            EventBus.getDefault().post(new UserListEvent(users));
                        }
                    },
                    new Response.Listener<APIError>() {
                        @Override
                        public void onResponse(APIError error) {

                        }
                    });

            Requests.addToRequestQueue(mActivity, request);
        }

        public void makeVerifyRequest(User user, final int position) {
            VerifyUserRequest request = new VerifyUserRequest(mActivity, user, new Response.Listener<User>() {
                @Override
                public void onResponse(User user) {
                    EventBus.getDefault().post(new VerifyUserEvent(user, position));
                }
            }, new Response.Listener<APIError>() {
                @Override
                public void onResponse(APIError error) {

                }
            });

            Requests.addToRequestQueue(mActivity, request);
        }

        public void makeDeleteRequest(User user, final int position) {
            DeleteUserRequest request = new DeleteUserRequest(mActivity, user, new Response.Listener<User>() {
                @Override
                public void onResponse(User user) {
                    EventBus.getDefault().post(new DeleteUserEvent(user, position));
                }
            }, new Response.Listener<APIError>() {
                @Override
                public void onResponse(APIError error) {

                }
            });

            Requests.addToRequestQueue(mActivity, request);
        }
    }

    public static class CheckIns {

        private Activity mActivity;

        public CheckIns(Activity activity) {
            mActivity = activity;
        }

        public static CheckIns with(Activity activity) {
            return new CheckIns(activity);
        }

        public void makeListRequest(HashMap<String, String> queryParams) {
            CheckInListRequest request = new CheckInListRequest(mActivity, queryParams,
                    new Response.Listener<ArrayList<CheckIn>>() {
                        @Override
                        public void onResponse(ArrayList<CheckIn> checkIns) {
                            EventBus.getDefault().post(new CheckInListEvent(checkIns));
                        }
                    },
                    new Response.Listener<APIError>() {
                        @Override
                        public void onResponse(APIError error) {

                        }
                    });

            Requests.addToRequestQueue(mActivity, request);
        }

        public void makeDeleteRequest(CheckIn checkIn, final int position) {
            DeleteCheckInRequest request = new DeleteCheckInRequest(mActivity, checkIn,
                    new Response.Listener<CheckIn>() {
                        @Override
                        public void onResponse(CheckIn checkIn) {
                            EventBus.getDefault().post(new DeleteCheckInEvent(checkIn, position));
                        }
                    },
                    new Response.Listener<APIError>() {
                        @Override
                        public void onResponse(APIError error) {

                        }
                    });

            Requests.addToRequestQueue(mActivity, request);
        }

        public void makeVerifyRequest(CheckIn checkIn, final int position) {
            VerifyCheckInRequest request = new VerifyCheckInRequest(mActivity, checkIn,
                    new Response.Listener<CheckIn>() {
                        @Override
                        public void onResponse(CheckIn checkIn) {
                            EventBus.getDefault().post(new VerifyCheckInEvent(checkIn, position));
                        }
                    },
                    new Response.Listener<APIError>() {
                        @Override
                        public void onResponse(APIError error) {

                        }
                    });

            Requests.addToRequestQueue(mActivity, request);
        }
    }
}
