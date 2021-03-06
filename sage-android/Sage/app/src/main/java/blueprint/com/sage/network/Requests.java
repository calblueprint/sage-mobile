package blueprint.com.sage.network;

import android.app.Activity;
import android.content.Context;
import android.support.v4.app.FragmentActivity;

import com.android.volley.Request;
import com.android.volley.Response;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import blueprint.com.sage.events.APIErrorEvent;
import blueprint.com.sage.events.SessionEvent;
import blueprint.com.sage.events.announcements.AnnouncementEvent;
import blueprint.com.sage.events.announcements.AnnouncementsListEvent;
import blueprint.com.sage.events.announcements.CreateAnnouncementEvent;
import blueprint.com.sage.events.announcements.DeleteAnnouncementEvent;
import blueprint.com.sage.events.announcements.EditAnnouncementEvent;
import blueprint.com.sage.events.checkIns.CheckInEvent;
import blueprint.com.sage.events.checkIns.CheckInListEvent;
import blueprint.com.sage.events.checkIns.DeleteCheckInEvent;
import blueprint.com.sage.events.checkIns.VerifyCheckInEvent;
import blueprint.com.sage.events.schools.CreateSchoolEvent;
import blueprint.com.sage.events.schools.DeleteSchoolEvent;
import blueprint.com.sage.events.schools.EditSchoolEvent;
import blueprint.com.sage.events.schools.SchoolEvent;
import blueprint.com.sage.events.schools.SchoolListEvent;
import blueprint.com.sage.events.semesters.ExportSemesterEvent;
import blueprint.com.sage.events.semesters.FinishSemesterEvent;
import blueprint.com.sage.events.semesters.JoinSemesterEvent;
import blueprint.com.sage.events.semesters.PauseSemesterEvent;
import blueprint.com.sage.events.semesters.SemesterEvent;
import blueprint.com.sage.events.semesters.SemesterListEvent;
import blueprint.com.sage.events.semesters.StartSemesterEvent;
import blueprint.com.sage.events.sessions.ResetPasswordEvent;
import blueprint.com.sage.events.sessions.SignInEvent;
import blueprint.com.sage.events.user_semesters.UpdateUserSemesterEvent;
import blueprint.com.sage.events.users.CreateAdminEvent;
import blueprint.com.sage.events.users.CreateUserEvent;
import blueprint.com.sage.events.users.DeleteUserEvent;
import blueprint.com.sage.events.users.EditUserEvent;
import blueprint.com.sage.events.users.PromoteUserEvent;
import blueprint.com.sage.events.users.RegisterUserEvent;
import blueprint.com.sage.events.users.UserEvent;
import blueprint.com.sage.events.users.UserListEvent;
import blueprint.com.sage.events.users.VerifyUserEvent;
import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.APISuccess;
import blueprint.com.sage.models.Announcement;
import blueprint.com.sage.models.CheckIn;
import blueprint.com.sage.models.School;
import blueprint.com.sage.models.Semester;
import blueprint.com.sage.models.Session;
import blueprint.com.sage.models.User;
import blueprint.com.sage.models.UserSemester;
import blueprint.com.sage.network.announcements.AnnouncementRequest;
import blueprint.com.sage.network.announcements.AnnouncementsListRequest;
import blueprint.com.sage.network.announcements.CreateAnnouncementRequest;
import blueprint.com.sage.network.announcements.DeleteAnnouncementRequest;
import blueprint.com.sage.network.announcements.EditAnnouncementRequest;
import blueprint.com.sage.network.check_ins.CheckInListRequest;
import blueprint.com.sage.network.check_ins.CreateCheckInRequest;
import blueprint.com.sage.network.check_ins.DeleteCheckInRequest;
import blueprint.com.sage.network.check_ins.VerifyCheckInRequest;
import blueprint.com.sage.network.schools.CreateSchoolRequest;
import blueprint.com.sage.network.schools.DeleteSchoolRequest;
import blueprint.com.sage.network.schools.EditSchoolRequest;
import blueprint.com.sage.network.schools.SchoolListRequest;
import blueprint.com.sage.network.schools.SchoolRequest;
import blueprint.com.sage.network.semesters.ExportSemesterRequest;
import blueprint.com.sage.network.semesters.FinishSemesterRequest;
import blueprint.com.sage.network.semesters.JoinSemesterRequest;
import blueprint.com.sage.network.semesters.PauseSemesterRequest;
import blueprint.com.sage.network.semesters.SemesterListRequest;
import blueprint.com.sage.network.semesters.SemesterRequest;
import blueprint.com.sage.network.semesters.StartSemesterRequest;
import blueprint.com.sage.network.sessions.ResetPasswordRequest;
import blueprint.com.sage.network.sessions.SignInRequest;
import blueprint.com.sage.network.user_semesters.UpdateUserSemesterRequest;
import blueprint.com.sage.network.users.CreateAdminRequest;
import blueprint.com.sage.network.users.CreateUserRequest;
import blueprint.com.sage.network.users.DeleteUserRequest;
import blueprint.com.sage.network.users.EditUserRequest;
import blueprint.com.sage.network.users.PromoteUserRequest;
import blueprint.com.sage.network.users.RegisterUserRequest;
import blueprint.com.sage.network.users.UserListRequest;
import blueprint.com.sage.network.users.UserRequest;
import blueprint.com.sage.network.users.UserStateRequest;
import blueprint.com.sage.network.users.VerifyUserRequest;
import blueprint.com.sage.utility.network.NetworkManager;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 11/15/15.
 * All the requests we make!
 */
public class Requests {

    public static void addToRequestQueue(Context context, Request request) {
        NetworkManager.getInstance(context).getRequestQueue().add(request);
    }

    public static void postEvent(Object event, boolean isSticky) {
        if (isSticky) {
            EventBus.getDefault().postSticky(event);
        } else {
            EventBus.getDefault().post(event);
        }
    }

    public static void postError(APIError error) {
        EventBus.getDefault().post(new APIErrorEvent(error));
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
                        public void onResponse(APIError apiError) {
                            Requests.postError(apiError);
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
                public void onResponse(APIError apiError) {
                    Requests.postError(apiError);
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
                public void onResponse(APIError apiError) {
                    Requests.postError(apiError);
                }
            });

            Requests.addToRequestQueue(mActivity, request);
        }

        public void makeCreateUserRequest(User user) {
            CreateUserRequest request = new CreateUserRequest(mActivity, user,
                    new Response.Listener<Session>() {
                        @Override
                        public void onResponse(Session session) {
                            EventBus.getDefault().post(new CreateUserEvent(session));
                        }
                    }, new Response.Listener<APIError>() {
                @Override
                public void onResponse(APIError apiError) {
                    Requests.postError(apiError);
                }
            });

            Requests.addToRequestQueue(mActivity, request);
        }

        public void makeStickyEditRequest(User user) {
            EditUserRequest request = new EditUserRequest(mActivity, user,
                    new Response.Listener<User>() {
                        @Override
                        public void onResponse(User user) {
                            Requests.postEvent(new EditUserEvent(user), true);
                        }
                    }, new Response.Listener<APIError>() {
                @Override
                public void onResponse(APIError apiError) {
                    Requests.postError(apiError);
                }
            });
            Requests.addToRequestQueue(mActivity, request);
        }

        public void makeCreateAdminRequest(User user) {
            CreateAdminRequest request = new CreateAdminRequest(mActivity, user,
                    new Response.Listener<User>() {
                        @Override
                        public void onResponse(User user) {
                            EventBus.getDefault().post(new CreateAdminEvent(user));
                        }
                    }, new Response.Listener<APIError>() {
                @Override
                public void onResponse(APIError apiError) {
                    Requests.postError(apiError);
                }
            });

            Requests.addToRequestQueue(mActivity, request);
        }

        public void makeShowRequest(User user, HashMap<String, String> queryParams) {
            UserRequest request = new UserRequest(mActivity, user, queryParams,
                    new Response.Listener<User>() {
                        @Override
                        public void onResponse(User user) {
                            EventBus.getDefault().post(new UserEvent(user));
                        }
                    }, new Response.Listener<APIError>() {
                @Override
                public void onResponse(APIError apiError) {
                    Requests.postError(apiError);
                }
            });

            Requests.addToRequestQueue(mActivity, request);
        }

        public void makePromoteRequest(User user) {
            PromoteUserRequest request = new PromoteUserRequest(mActivity, user,
                    new Response.Listener<User>() {
                        @Override
                        public void onResponse(User user) {
                            EventBus.getDefault().post(new PromoteUserEvent(user));
                        }
                    }, new Response.Listener<APIError>() {
                @Override
                public void onResponse(APIError apiError) {
                    Requests.postError(apiError);
                }
            });

            Requests.addToRequestQueue(mActivity, request);
        }

        public void makeStateRequest(User user) {
            UserStateRequest request = new UserStateRequest(mActivity, user,
                    new Response.Listener<Session>() {
                        @Override
                        public void onResponse(Session session) {
                            EventBus.getDefault().post(new SessionEvent(session));
                        }
                    },
                    new Response.Listener<APIError>() {
                        @Override
                        public void onResponse(APIError apiError) {
                            Requests.postError(apiError);
                        }
                    });

            Requests.addToRequestQueue(mActivity, request);
        }

        public void makeRegistrationRequest(User user) {
            RegisterUserRequest request = new RegisterUserRequest(mActivity, user, new Response.Listener<Session>() {
                @Override
                public void onResponse(Session session) {
                    Requests.postEvent(new RegisterUserEvent(session), false);
                }
            }, new Response.Listener<APIError>() {
                @Override
                public void onResponse(APIError apiError) {
                    Requests.postError(apiError);
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
                        public void onResponse(APIError apiError) {
                            Requests.postError(apiError);
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
                        public void onResponse(APIError apiError) {
                            Requests.postError(apiError);
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
                        public void onResponse(APIError apiError) {
                            Requests.postError(apiError);
                        }
                    });

            Requests.addToRequestQueue(mActivity, request);
        }

        public void makeCreateRequest(CheckIn checkIn) {
            CreateCheckInRequest request = new CreateCheckInRequest(mActivity, checkIn,
                    new Response.Listener<CheckIn>() {
                        @Override
                        public void onResponse(CheckIn checkIn) {
                            EventBus.getDefault().post(new CheckInEvent(checkIn));

                        }
                    },
                    new Response.Listener<APIError>() {
                        @Override
                        public void onResponse(APIError apiError) {
                            Requests.postError(apiError);
                        }
                    });

            Requests.addToRequestQueue(mActivity, request);
        }
    }

    public static class Schools {
        private Activity mActivity;

        public Schools(Activity activity) {
            mActivity = activity;
        }

        public static Schools with(Activity activity) {
            return new Schools(activity);
        }

        public void makeListRequest(HashMap<String, String> queryParams) {
            SchoolListRequest request = new SchoolListRequest(mActivity, queryParams,
                    new Response.Listener<ArrayList<School>>() {
                        @Override
                        public void onResponse(ArrayList<School> schools) {
                            EventBus.getDefault().post(new SchoolListEvent(schools));
                        }
                    },
                    new Response.Listener<APIError>() {
                        @Override
                        public void onResponse(APIError apiError) {
                            Requests.postError(apiError);
                        }
                    });

            Requests.addToRequestQueue(mActivity, request);
        }

        public void makeCreateRequest(School school) {
            CreateSchoolRequest request = new CreateSchoolRequest(mActivity, school,
                    new Response.Listener<School>() {
                        @Override
                        public void onResponse(School school) {
                            EventBus.getDefault().post(new CreateSchoolEvent(school));
                        }
                    }, new Response.Listener<APIError>() {
                @Override
                public void onResponse(APIError apiError) {
                    Requests.postError(apiError);
                }
            });

            Requests.addToRequestQueue(mActivity, request);
        }

        public void makeShowRequest(School school, HashMap<String, String> queryParams) {
            SchoolRequest request = new SchoolRequest(mActivity, school, queryParams,
                    new Response.Listener<School>() {
                        @Override
                        public void onResponse(School school) {
                            EventBus.getDefault().post(new SchoolEvent(school));
                        }
                    }, new Response.Listener<APIError>() {
                @Override
                public void onResponse(APIError apiError) {
                    Requests.postError(apiError);
                }
            });

            Requests.addToRequestQueue(mActivity, request);
        }

        public void makeEditRequest(School school) {
            EditSchoolRequest request = new EditSchoolRequest(mActivity, school,
                    new Response.Listener<School>() {
                        @Override
                        public void onResponse(School school) {
                            EventBus.getDefault().post(new EditSchoolEvent(school));
                        }
                    }, new Response.Listener<APIError>() {
                @Override
                public void onResponse(APIError apiError) {
                    Requests.postError(apiError);
                }
            });

            Requests.addToRequestQueue(mActivity, request);
        }

        public void makeDeleteRequest(School school) {
            DeleteSchoolRequest request = new DeleteSchoolRequest(mActivity, school,
                    new Response.Listener<School>() {
                        @Override
                        public void onResponse(School school) {
                            EventBus.getDefault().post(new DeleteSchoolEvent(school));
                        }
                    }, new Response.Listener<APIError>() {
                @Override
                public void onResponse(APIError apiError) {
                    Requests.postError(apiError);
                }
            });

            Requests.addToRequestQueue(mActivity, request);
        }
    }

    public static class Announcements {
        private FragmentActivity mActivity;

        public Announcements(FragmentActivity activity) {
            mActivity = activity;
        }

        public static Announcements with(FragmentActivity activity) {
            return new Announcements(activity);
        }

        public void makeListRequest(HashMap<String, String> params) {
            AnnouncementsListRequest announcementsRequest = new AnnouncementsListRequest(mActivity, params, new Response.Listener<ArrayList<Announcement>>() {
                @Override
                public void onResponse(ArrayList<Announcement> announcementsArrayList) {
                    EventBus.getDefault().post(new AnnouncementsListEvent(announcementsArrayList));
                }
            }, new Response.Listener<APIError>() {
                @Override
                public void onResponse(APIError apiError) {
                    Requests.postError(apiError);
                }
            });
            Requests.addToRequestQueue(mActivity, announcementsRequest);
        }

        public void makeShowRequest(Announcement announcement) {
            AnnouncementRequest request = new AnnouncementRequest(mActivity, announcement.getId(),
                    new Response.Listener<Announcement>() {
                        @Override
                        public void onResponse(Announcement announcement) {
                            EventBus.getDefault().post(new AnnouncementEvent(announcement));
                        }
                    }, new Response.Listener<APIError>() {
                @Override
                public void onResponse(APIError apiError) {
                    Requests.postError(apiError);
                }
            });

            Requests.addToRequestQueue(mActivity, request);
        }

        public void makeCreateRequest(Announcement announcement) {
            CreateAnnouncementRequest request = new CreateAnnouncementRequest(mActivity, announcement,
                    new Response.Listener<Announcement>() {
                        @Override
                        public void onResponse(Announcement announcement) {
                            EventBus.getDefault().post(new CreateAnnouncementEvent(announcement));
                        }
                    }, new Response.Listener<APIError>() {
                @Override
                public void onResponse(APIError apiError) {
                    Requests.postError(apiError);
                }
            });
            Requests.addToRequestQueue(mActivity, request);
        }

        public void makeDeleteRequest(Announcement announcement) {
            DeleteAnnouncementRequest request = new DeleteAnnouncementRequest(mActivity, announcement,
                    new Response.Listener<Announcement>() {
                        @Override
                        public void onResponse(Announcement announcement) {
                            EventBus.getDefault().post(new DeleteAnnouncementEvent(announcement));
                        }
                    }, new Response.Listener<APIError>() {
                @Override
                public void onResponse(APIError apiError) {
                    Requests.postError(apiError);
                }
            });
            Requests.addToRequestQueue(mActivity, request);
        }

        public void makeEditRequest(Announcement announcement) {
            EditAnnouncementRequest request = new EditAnnouncementRequest(mActivity, announcement,
                    new Response.Listener<Announcement>() {
                        @Override
                        public void onResponse(Announcement announcement) {
                            EventBus.getDefault().post(new EditAnnouncementEvent(announcement));
                        }
                    }, new Response.Listener<APIError>() {
                @Override
                public void onResponse(APIError apiError) {
                    Requests.postError(apiError);
                }
            });
            Requests.addToRequestQueue(mActivity, request);
        }
    }

    public static class Sessions {
        private FragmentActivity mActivity;

        public Sessions(FragmentActivity activity) {
            mActivity = activity;
        }

        public static Sessions with(FragmentActivity activity) {
            return new Sessions(activity);
        }

        public void makeSignInRequest(HashMap<String, String> params) {
            SignInRequest loginRequest = new SignInRequest(mActivity, params, new Response.Listener<Session>() {
                @Override
                public void onResponse(Session session) {
                    EventBus.getDefault().post(new SignInEvent(session));
                }
            }, new Response.Listener<APIError>() {
                @Override
                public void onResponse(APIError apiError) {
                    Requests.postError(apiError);
                }
            });
            Requests.addToRequestQueue(mActivity, loginRequest);
        }

        public void makeResetPasswordRequest(HashMap<String, String> params) {
            ResetPasswordRequest request = new ResetPasswordRequest(mActivity, params,
                    new Response.Listener<APISuccess>() {
                        @Override
                        public void onResponse(APISuccess apiSuccess) {
                            Requests.postEvent(new ResetPasswordEvent(apiSuccess), false);
                        }

                    }, new Response.Listener<APIError>() {
                @Override
                public void onResponse(APIError apiError) {
                    Requests.postError(apiError);
                }
            });

            Requests.addToRequestQueue(mActivity, request);
        }
    }

    public static class Semesters {
        private FragmentActivity mActivity;

        public Semesters(FragmentActivity activity) { mActivity = activity; }

        public static Semesters with(FragmentActivity activity) { return new Semesters(activity); }

        public void makeStartRequest(Semester semester) {
            Request request = new StartSemesterRequest(mActivity, semester,
                    new Response.Listener<Semester>() {
                        @Override
                        public void onResponse(Semester semester) {
                            EventBus.getDefault().post(new StartSemesterEvent(semester));
                        }
                    },
                    new Response.Listener<APIError>() {
                        @Override
                        public void onResponse(APIError apiError) {
                            Requests.postError(apiError);
                        }
                    });

            Requests.addToRequestQueue(mActivity, request);
        }

        public void makeFinishRequest(Semester semester) {
            Request request = new FinishSemesterRequest(mActivity, semester,
                    new Response.Listener<Semester>() {
                        @Override
                        public void onResponse(Semester semester) {
                            EventBus.getDefault().post(new FinishSemesterEvent(semester));
                        }
                    },
                    new Response.Listener<APIError>() {
                        @Override
                        public void onResponse(APIError apiError) {
                            Requests.postError(apiError);
                        }
                    });

            Requests.addToRequestQueue(mActivity, request);
        }

        public void makeShowRequest(Semester semester) {
            Request request = new SemesterRequest(mActivity, semester,
                    new Response.Listener<Semester>() {
                        @Override
                        public void onResponse(Semester semester) {
                            EventBus.getDefault().post(new SemesterEvent(semester));
                        }
                    }, new Response.Listener<APIError>() {
                @Override
                public void onResponse(APIError apiError) {
                    Requests.postError(apiError);
                }
            });

            Requests.addToRequestQueue(mActivity, request);
        }

        public void makeListRequest(HashMap<String, String> queryParams) {
            Request request = new SemesterListRequest(mActivity, queryParams,
                    new Response.Listener<List<Semester>>() {
                        @Override
                        public void onResponse(List<Semester> semesters) {
                            EventBus.getDefault().post(new SemesterListEvent(semesters));
                        }
                    },
                    new Response.Listener<APIError>() {
                        @Override
                        public void onResponse(APIError apiError) {
                            Requests.postError(apiError);
                        }
                    });

            Requests.addToRequestQueue(mActivity, request);
        }

        public void makeJoinRequest() {
            Request request = new JoinSemesterRequest(mActivity,
                    new Response.Listener<Session>() {
                        @Override
                        public void onResponse(Session session) {
                            EventBus.getDefault().post(new JoinSemesterEvent(session));
                        }
                    },
                    new Response.Listener<APIError>() {
                        @Override
                        public void onResponse(APIError apiError) {
                            Requests.postError(apiError);
                        }
                    });

            Requests.addToRequestQueue(mActivity, request);
        }

        public void makeExportRequest(Semester semester) {
            Request request = new ExportSemesterRequest(mActivity, semester,
                    new Response.Listener<APISuccess>() {
                        @Override
                        public void onResponse(APISuccess success) {
                            Requests.postEvent(new ExportSemesterEvent(success), false);
                        }
                    }, new Response.Listener<APIError>() {
                @Override
                public void onResponse(APIError apiError) {
                    Requests.postError(apiError);
                }
            });

            Requests.addToRequestQueue(mActivity, request);
        }

        public void makePauseRequest(Semester semester) {
            Request request = new PauseSemesterRequest(mActivity, semester,
                    new Response.Listener<Semester>() {
                        @Override
                        public void onResponse(Semester semester) {
                            Requests.postEvent(new PauseSemesterEvent(semester), false);
                        }
                    },
                    new Response.Listener<APIError>() {
                        @Override
                        public void onResponse(APIError apiError) {
                            Requests.postError(apiError);
                        }
                    });

            Requests.addToRequestQueue(mActivity, request);
        }
    }

    public static class UserSemesters {
        private FragmentActivity mActivity;

        public UserSemesters(FragmentActivity activity) { mActivity = activity; }

        public static UserSemesters with(FragmentActivity activity) { return new UserSemesters(activity); }

        public void makeUpdateRequest(UserSemester userSemester) {
            Request request = new UpdateUserSemesterRequest(mActivity, userSemester,
                    new Response.Listener<UserSemester>() {
                        @Override
                        public void onResponse(UserSemester userSemester) {
                            EventBus.getDefault().post(new UpdateUserSemesterEvent(userSemester));
                        }
                    },
                    new Response.Listener<APIError>() {
                        @Override
                        public void onResponse(APIError apiError) {
                            Requests.postError(apiError);
                        }
                    });

            Requests.addToRequestQueue(mActivity, request);
        }
    }
}
