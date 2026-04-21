import { ApiHelper, CommonEnvironmentHelper, Locale } from "@churchapps/apphelper";

export class EnvironmentHelper {
  //static B1Url = "";
  static Common = CommonEnvironmentHelper;

  //static ContentRoot = "";
  //static GoogleAnalyticsTag = "";

  static init = async () => {
    const stage = import.meta.env.VITE_STAGE;
    console.log("STAGE IS", stage);

    // Set URLs from VITE_* env vars baked in at build time.
    // Do NOT call Common.init(stage) — it overwrites with ChurchApps defaults.
    EnvironmentHelper.Common.AttendanceApi = import.meta.env.VITE_ATTENDANCE_API || EnvironmentHelper.Common.AttendanceApi;
    EnvironmentHelper.Common.GivingApi = import.meta.env.VITE_GIVING_API || EnvironmentHelper.Common.GivingApi;
    EnvironmentHelper.Common.MembershipApi = import.meta.env.VITE_MEMBERSHIP_API || EnvironmentHelper.Common.MembershipApi;
    EnvironmentHelper.Common.ContentApi = import.meta.env.VITE_CONTENT_API || EnvironmentHelper.Common.ContentApi;
    EnvironmentHelper.Common.ContentRoot = import.meta.env.VITE_CONTENT_ROOT || EnvironmentHelper.Common.ContentRoot;
    EnvironmentHelper.Common.B1Root = import.meta.env.VITE_B1_URL || EnvironmentHelper.Common.B1Root;
    EnvironmentHelper.Common.B1AdminRoot = import.meta.env.VITE_B1_URL || EnvironmentHelper.Common.B1AdminRoot;

    ApiHelper.apiConfigs = [
      { keyName: "AttendanceApi", url: EnvironmentHelper.Common.AttendanceApi, jwt: "", permissions: [] },
      { keyName: "GivingApi", url: EnvironmentHelper.Common.GivingApi, jwt: "", permissions: [] },
      { keyName: "MembershipApi", url: EnvironmentHelper.Common.MembershipApi, jwt: "", permissions: [] },
      { keyName: "ContentApi", url: EnvironmentHelper.Common.ContentApi, jwt: "", permissions: [] }
    ];

    await Locale.init([`/locales/{{lng}}.json?v=1`, `/apphelper/locales/{{lng}}.json`]);
  };

  static initDev = () => { };
  static initStaging = () => { };
  static initProd = () => { };

}

