create table t_advise
(
    advise_id    int auto_increment
        primary key,
    community_id varchar(64)                        null,
    owner_id     varchar(64)                        null,
    type         int                                null comment '0实名投诉，1匿名投诉',
    department   varchar(100)                       null comment '投诉部门',
    content      varchar(500)                       null comment '投诉内容',
    createTime   datetime default CURRENT_TIMESTAMP null
)
    comment '投诉表';

create table t_flow
(
    flow_id   int         not null
        primary key,
    flow_name varchar(64) null
);

create table t_flow_node
(
    flow_node_id   int          not null,
    flow_node_name varchar(100) null,
    flow_node_role varchar(100) null,
    flow_id        int          null,
    constraint t_flow_node_flow_node_id_uindex
        unique (flow_node_id),
    constraint t_flow_node_t_flow_flow_id_fk
        foreign key (flow_id) references t_flow (flow_id)
);

alter table t_flow_node
    add primary key (flow_node_id);

create table t_flow_line
(
    flow_line_id int not null,
    prev_node_id int null,
    next_node_id int null,
    flow_id      int null,
    constraint t_flow_line_flow_line_id_uindex
        unique (flow_line_id),
    constraint t_flow_line_t_flow_flow_id_fk
        foreign key (flow_id) references t_flow (flow_id),
    constraint t_flow_line_t_flow_node_flow_node_id_fk
        foreign key (prev_node_id) references t_flow_node (flow_node_id),
    constraint t_flow_line_t_flow_node_flow_node_id_fk_2
        foreign key (next_node_id) references t_flow_node (flow_node_id)
);

alter table t_flow_line
    add primary key (flow_line_id);

create table t_promise
(
    promise_id   varchar(64) not null,
    promise_name varchar(10) not null,
    constraint t_promise_promise_id_uindex
        unique (promise_id),
    constraint t_promise_promise_name_uindex
        unique (promise_name)
);

alter table t_promise
    add primary key (promise_id);

create table t_region
(
    region_id   bigint auto_increment
        primary key,
    create_date datetime     not null,
    modify_date datetime     not null,
    version     bigint       not null,
    orders      int          null,
    full_name   longtext     not null,
    grade       int          not null,
    name        varchar(255) not null,
    tree_path   varchar(255) not null,
    parent      bigint       null
)
    comment '地区表';

create table t_admin
(
    admin_id       varchar(64)   not null,
    admin_account  varchar(20)   not null,
    admin_password varchar(255)  null,
    region_id      bigint        null,
    admin_modify   int default 0 null,
    constraint t_admin_admin_account_uindex
        unique (admin_account),
    constraint t_admin_admin_id_uindex
        unique (admin_id),
    constraint t_admin_t_region_fk
        foreign key (region_id) references t_region (region_id)
)
    comment '管理员表';

alter table t_admin
    add primary key (admin_id);

create index FK_5047kis16ai84i5pjbry5t90a
    on t_region (parent);

create table t_role
(
    role_id   varchar(64) not null,
    role_name varchar(10) null,
    constraint t_role_role_id_uindex
        unique (role_id)
);

alter table t_role
    add primary key (role_id);

create table t_admin_role
(
    role_id  varchar(64) not null,
    admin_id varchar(64) not null,
    primary key (role_id, admin_id),
    constraint t_admin_role_t_admin_admin_id_fk
        foreign key (admin_id) references t_admin (admin_id),
    constraint t_admin_role_t_role_role_id_fk
        foreign key (role_id) references t_role (role_id)
);

create table t_role_promise
(
    promise_id varchar(64) not null,
    role_id    varchar(64) not null,
    primary key (promise_id, role_id),
    constraint t_role_promise_t_promise_promise_id_fk
        foreign key (promise_id) references t_promise (promise_id),
    constraint t_role_promise_t_role_role_id_fk
        foreign key (role_id) references t_role (role_id)
);

create table t_ten
(
    ten_id    varchar(64)  not null,
    ten_name  varchar(100) null,
    ten_phone varchar(100) null,
    constraint t_ten_ten_id_uindex
        unique (ten_id)
);

alter table t_ten
    add primary key (ten_id);

create table t_community
(
    community_id   varchar(64)  not null,
    community_name varchar(100) null,
    region_id      bigint       null,
    community_info varchar(255) null,
    ten_id         varchar(64)  null,
    constraint t_community_community_id_uindex
        unique (community_id),
    constraint t_community_t_region_fk
        foreign key (region_id) references t_region (region_id),
    constraint t_community_t_ten_ten_id_fk
        foreign key (ten_id) references t_ten (ten_id)
)
    comment '小区表';

alter table t_community
    add primary key (community_id);

create table t_committee
(
    committee_id            varchar(64) not null,
    committee_people_number int         null,
    community_id            varchar(64) null,
    committee_term          int         null comment '第几届业委会',
    constraint t_committee_committee_id_uindex
        unique (committee_id),
    constraint t_committee_t_community_community_id_fk
        foreign key (community_id) references t_community (community_id)
)
    comment '业委会表';

alter table t_committee
    add primary key (committee_id);

create table t_house
(
    house_id     varchar(64)  not null,
    house_name   varchar(100) null,
    community_id varchar(64)  null,
    constraint t_house_house_id_uindex
        unique (house_id),
    constraint t_house_t_community_community_id_fk
        foreign key (community_id) references t_community (community_id)
);

alter table t_house
    add primary key (house_id);

create table t_issue
(
    issue_id         varchar(64)   not null,
    issue_title      varchar(128)  not null,
    issue_content    varchar(1024) not null,
    issue_agree      int           null,
    issue_waiver     int           null,
    issue_oppose     int           null,
    issue_start_time bigint        null,
    issue_end_time   bigint        null,
    issue_status     int           null,
    committee_id     varchar(64)   null,
    constraint t_issue_issue_id_uindex
        unique (issue_id),
    constraint t_issue_t_committee_committee_id_fk
        foreign key (committee_id) references t_committee (committee_id)
)
    comment '议题表';

alter table t_issue
    add primary key (issue_id);

create table t_manager
(
    manager_id   varchar(64) not null comment '管理员号'
        primary key,
    community_id varchar(64) null comment '小区号',
    account      varchar(64) null comment '账号',
    password     varchar(64) null comment '密码',
    type         int         null comment '管理员类型',
    login_time   bigint      null comment '登录时间',
    constraint t_manager_t_community_community_id_fk
        foreign key (community_id) references t_community (community_id)
            on update cascade on delete cascade
)
    comment '小区管理员表';

create table t_notice
(
    notice_id    int auto_increment comment '公告主键'
        primary key,
    title        varchar(500)                       null comment '公告标题',
    content      varchar(10000)                     null comment '公告内容',
    type         int                                null comment '公告的类型',
    createTime   datetime default CURRENT_TIMESTAMP null,
    community_id varchar(64)                        null comment '小区号',
    constraint t_notice_t_community_community_id_fk
        foreign key (community_id) references t_community (community_id)
)
    comment '公告表';

create table t_owner
(
    owner_id            varchar(64)   not null,
    owner_name          varchar(50)   null,
    owner_phone         varchar(11)   null,
    owner_id_number     varchar(50)   null,
    owner_weixin_id     varchar(100)  null,
    owner_office_trime  bigint        null,
    committee_id        varchar(64)   null,
    authentication_flag int default 0 null,
    avatar              varchar(200)  null comment '头像',
    avatar_url          varchar(200)  null comment '头像地址',
    constraint t_owner_owner_id_uindex
        unique (owner_id),
    constraint t_owner_t_committee_committee_id_fk
        foreign key (committee_id) references t_committee (committee_id)
)
    comment '业主表';

alter table t_owner
    add primary key (owner_id);

create table t_candidate
(
    candidate_id            varchar(64)   not null
        primary key,
    candidate_head_portrait varchar(128)  null,
    candidate_head_path     varchar(256)  null,
    owner_id                varchar(64)   null,
    community_id            varchar(64)   null,
    candidate_poll          int default 0 null comment '票数',
    candidate_create_time   bigint        null,
    is_current              int default 0 null comment '是否是当前届，是为0，不是为1',
    constraint t_candidate_t_community_community_id_fk
        foreign key (community_id) references t_community (community_id),
    constraint t_candidate_t_owner_owner_id_fk
        foreign key (owner_id) references t_owner (owner_id)
);

create table t_candidate_owner
(
    candidate_id varchar(64) not null,
    owner_id     varchar(64) not null,
    primary key (owner_id, candidate_id),
    constraint t_candidate_owner_t_candidate_candidate_id_fk
        foreign key (candidate_id) references t_candidate (candidate_id),
    constraint t_candidate_owner_t_owner_owner_id_fk
        foreign key (owner_id) references t_owner (owner_id)
);

create table t_fix
(
    fix_id       varchar(64)                        not null
        primary key,
    community_id varchar(64)                        null,
    type         varchar(100)                       not null comment '维修类型',
    date         varchar(100)                       null comment '上门日期',
    time         varchar(100)                       null comment '上门时间',
    text         varchar(500)                       null comment '问题描述',
    flag         int      default 0                 null comment '接收标志位',
    owner_id     varchar(64)                        null comment '报修业主',
    createTime   datetime default CURRENT_TIMESTAMP null,
    updateTime   datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint t_fix_t_community_community_id_fk
        foreign key (community_id) references t_community (community_id),
    constraint t_fix_t_owner_owner_id_fk
        foreign key (owner_id) references t_owner (owner_id)
)
    comment '维修表';

create table t_room
(
    room_id                 varchar(64) not null,
    room_name               varchar(64) null,
    room_certification_time bigint      null,
    owner_id                varchar(64) null,
    house_id                varchar(64) null,
    constraint t_room_room_id_uindex
        unique (room_id),
    constraint t_room_t_house_house_id_fk
        foreign key (house_id) references t_house (house_id),
    constraint t_room_t_owner_owner_id_fk
        foreign key (owner_id) references t_owner (owner_id)
);

create table t_apply
(
    apply_id     varchar(64) not null,
    owner_id     varchar(64) null,
    community_id varchar(64) null,
    flow_node_id int         null,
    apply_state  int         null,
    house_id     varchar(64) null,
    room_id      varchar(64) null,
    create_time  bigint      null comment '创建时间
',
    flow_id      int         null,
    constraint t_apply_apply_id_uindex
        unique (apply_id),
    constraint apply_community
        foreign key (community_id) references t_community (community_id),
    constraint apply_house
        foreign key (house_id) references t_house (house_id),
    constraint apply_owner
        foreign key (owner_id) references t_owner (owner_id),
    constraint apply_room
        foreign key (room_id) references t_room (room_id),
    constraint t_apply_t_flow_flow_id_fk
        foreign key (flow_id) references t_flow (flow_id),
    constraint t_apply_t_flow_node_flow_node_id_fk
        foreign key (flow_node_id) references t_flow_node (flow_node_id)
)
    comment '申请表';

alter table t_apply
    add primary key (apply_id);

create table t_file
(
    file_id   varchar(64)  not null,
    file_name varchar(255) null,
    file_path varchar(255) null,
    apply_id  varchar(64)  null,
    constraint t_file_file_id_uindex
        unique (file_id),
    constraint t_file_t_apply_apply_id_fk
        foreign key (apply_id) references t_apply (apply_id)
);

alter table t_file
    add primary key (file_id);

create table t_leave_audit
(
    audit_id        varchar(64)  not null,
    apply_id        varchar(64)  null,
    admin_id        varchar(64)  null,
    admin_name      varchar(100) null,
    audit_state     int          null,
    audit_info      varchar(500) null,
    audit_date      bigint       null,
    flow_node_id    int          null,
    audit_file_name varchar(128) null,
    audit_file_path varchar(255) null,
    constraint t_leave_line_audit_id_uindex
        unique (audit_id),
    constraint t_leave_audit_t_admin_admin_id_fk
        foreign key (admin_id) references t_admin (admin_id),
    constraint t_leave_audit_t_apply_apply_id_fk
        foreign key (apply_id) references t_apply (apply_id),
    constraint t_leave_audit_t_flow_node_flow_node_id_fk
        foreign key (flow_node_id) references t_flow_node (flow_node_id)
);

alter table t_leave_audit
    add primary key (audit_id);

create table t_vote
(
    vote_flag int         null,
    issue_id  varchar(64) not null,
    owner_id  varchar(64) not null,
    primary key (issue_id, owner_id),
    constraint t_vote_t_issue_issue_id_fk
        foreign key (issue_id) references t_issue (issue_id),
    constraint t_vote_t_owner_owner_id_fk
        foreign key (owner_id) references t_owner (owner_id)
);


