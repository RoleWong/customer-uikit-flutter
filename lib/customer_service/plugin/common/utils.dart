class CUSTOM_MESSAGE_SRC {
  // 公众号
  static const String OFFICIAL_ACCOUNT = '1';
  // 小程序
  static const String MINI_APP = '2';
  // 小程序服务号
  static const String MINI_APP_SERVICE_ACCOUNT = '3';
  // 后台内部
  static const String BACKEND_INTERNAL = '4';
  // 网页
  static const String WEB = '5';
  // 会话消息分割
  static const String SESSION_MESSAGE_SLICE = '6';
  // 小程序自动触发
  static const String MINI_APP_AUTO = '7';
  // 内部会话
  static const String INTERNAL = '8';
  // 菜单消息
  static const String MENU = '9';
  // 菜单选择
  static const String MENU_SELECTED = '10';
  // 客户端在线状态
  static const String CLIENT_STATE = '11';
  // 输入状态
  static const String TYPING_STATE = '12';
  // 文本机器人
  static const String ROBOT = '13';
  // 分支消息
  static const String BRANCH = '15';
  static const String MEMBER = '17';
  // 没有客服在线
  static const String NO_SEAT_ONLINE = '18';
  // 会话结束
  static const String END = '19';
  // 超时结束
  static const String TIMEOUT = '20';
  //
  static const String FROM_INPUT = '21';
  // 卡片
  static const String PRODUCT_CARD = '22';
  //
  static const String SATISFACTION_CON = '23';
  //
  static const String USER_SATISFACTION = '24';
  //
  static const String IN_BOT_STATUS = '25';
  //
  static const String USER_IN_SESSION = '26';
  //
  static const String USER_ENDSESSION = '27';
  // 订单卡片
  static const String ORDER_CARD = '28';
  // 机器人欢迎卡片
  static const String ROBOT_WELCOME_CARD = '29';
  // 富文本
  static const String RICH_TEXT = '30';
  // 流式消息
  static const String STREAM_TEXT = '31';
  // 分支消息2
  static const String BRANCH_MESSAGE = '32';
  // 表单收集
  static const String FORM_SAVE = '33';
  // 大模型思考中
  static const String MODEL_THINKING = '35';
}

class RATING_TEMPLATE_TYPE {
  // 星星
  static const int STAR = 1;
  // 数字
  static const int NUMBER = 2;
}

class ROBOT_COMMAND {
  static const String UPDATE_BUBBLE = 'updateBubble';
  static const String UPDATE_SEARCH_TIPS = 'updateSearchTips';
  static const String SHOW_DIALOG = 'showDialog';
  static const String FEEDBACK = 'feedback';
  static const String SELECT_RECOMMEND = 'selectRecommend';
  static const String SELECT_SEARCH_TIP = 'selectSearchTips';
  static const String UPDATE_BOT_STATUS = 'updateBotStatus';
}

class ROBOT_MESSAGE_TYPE {
  static const String SIMPLE_TEXT = 'simpleText';
  static const String RICH_TEXT = 'richText';
  static const String MULTI_LINE_TEXT = 'multiLineText';
  static const String CANDIDATE_ANSWER = 'candidateAnswer';
  static const String QUESTION_LIST = 'questionList';
}

class ROBOT_STATUS {
  static const String IN = 'inBot';
  static const String LEAVE = 'leaveBot';
}
