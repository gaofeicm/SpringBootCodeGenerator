package ${packageName}.service;

import com.alibaba.fastjson.JSONObject;
import org.apache.dubbo.config.annotation.Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import ${packageName}.common.service.BaseService;
import ${packageName}.exception.BizException;
import ${packageName}.entity.${classInfo.className};
import ${packageName}.repository.${classInfo.className}Repository;
import supersmart.utils.CommonUtils;
import supersmart.utils.response.Result;

import java.text.ParseException;
import java.util.Date;

/**
*  ${classInfo.classComment}
* @author ${authorName} ${.now?string('yyyy-MM-dd')}
*/
@Service
public class ${classInfo.className}Service extends BaseService {

    /**
     * 模块基本信息说明
     */
    private static final JSONObject MODULE_INFO = new JSONObject() {{
        put("_DESC", "");
        put("_TABLE_NAME", "${classInfo.tableName}");
        put("_PRIMARY_KEY", "");
        put("_PRIMARY_KEY_ATTR", "");
        put("_ENTITY_OBJECT", new ${classInfo.className}());
    }};

    /**
     * 注入持久层对象
     */
    @Autowired
    private ${classInfo.className}Repository repository;

    /**
     * 查询实体
     *
     * @param parameter 查询参数
     * @return
     * @throws Exception
     */
    @Override
    public Result getEntity(JSONObject parameter) throws Exception {
        Result result = new Result();
        try {
            result.success(super.query(parameter.fluentPutAll(MODULE_INFO)));
        } catch (Exception e) {
            new BizException("查询" + MODULE_INFO.getString("_DESC") + "出错！" + e.getMessage());
        }
        return result;
    }

    /**
     * 持久化实体对象
     *
     * @param parameter 实体
     * @return
     * @throws Exception
     */
    @Override
    @Transactional
    public Result saveEntity(JSONObject parameter) throws Exception {
        Result result = new Result();
        try {
            if (null != parameter.getString(MODULE_INFO.getString("_PRIMARY_KEY_ATTR")) && !"".equals(parameter.getString(MODULE_INFO.getString("_PRIMARY_KEY_ATTR")))) {
                result.success(super.update(parameter.fluentPutAll(MODULE_INFO)));
            } else {
                result = this.save(parameter);
            }
        } catch (Exception e) {
            String entityId = parameter.getString(MODULE_INFO.getString("_PRIMARY_KEY_ATTR"));
            String eStr = entityId != null && !"".equals(entityId) ? "更新" + MODULE_INFO.getString("_DESC") + "出错！" + e.getMessage() :
                    "添加" + MODULE_INFO.getString("_DESC") + "出错！" + e.getMessage();
            new BizException(eStr);
        }
        return result;
    }

    /**
     * 删除实体对象
     *
     * @param parameter 删除条件
     * @return
     * @throws Exception
     */
    @Override
    @Transactional
    public Result deleteEntity(JSONObject parameter) throws Exception {
        Result result = new Result();
        String ids = parameter.getString("ids");
        try {
            int count = 0;
            if (ids.length() > 0) {
                String[] idsArray = ids.split(",");
                for (int i = 0; i < idsArray.length; i++) {
                    //1、先删除关联数据
                    this.deleteRelationData(idsArray[i]);
                    //2、删除自身数据
                    this.deleteEntityById(idsArray[i]);
                    count++;
                }
            }
            result.success(count);
        } catch (Exception e) {
            new BizException("删除" + MODULE_INFO.getString("_DESC") + "出错！" + e.getMessage());
        }
        return result;
    }

    /**
     * 保存实体对象以及相关操作
     *
     * @param parameter 参数
     * @return 实体id
     * @throws Exception
     */
    private Result save(JSONObject parameter) throws Exception {
        Result result = new Result();
        try {
            ${classInfo.className} entity = CommonUtil.fillBean(parameter, ${classInfo.className}.class);
            repository.save(this.initEntity(entity, parameter));
            result.success(entity.getId());
        } catch (Exception e) {
            throw e;
        }
        return result;
    }

    /**
     * 删除自身数据
     *
     * @return 操作成功数
     * @throws Exception
     */
    private int deleteEntityById(String id) throws Exception {
        int count = 0;
        try {
            //判断是否伪删除
            if (super.pseudoDeletion) {
                super.update(new StringBuffer("UPDATE " + MODULE_INFO.getString("_TABLE_NAME") + " SET _is_delete = '1' WHERE " + MODULE_INFO.getString("_PRIMARY_KEY") + " = '" + id + "'"));
            } else {
                repository.deleteById(id);
            }
            count++;
        } catch (Exception e) {
            throw e;
        }
        return count;
    }

    /**
     * 删除关联数据
     *
     * @param id 主体id
     * @throws Exception
     */
    private void deleteRelationData(String id) throws Exception {
        try {
            //1、
        } catch (Exception e) {
            new BizException("删除" + MODULE_INFO.getString("_DESC") + "关联数据是出现了异常！错误信息 ： " + e.getMessage());
        }
    }

    /**
     * 初始化对象
     *
     * @param entity    实体对象
     * @param parameter 参数
     * @return 实体对象
     * @throws ParseException
     */
    private ${classInfo.className} initEntity(${classInfo.className} entity, JSONObject parameter) throws ParseException {
        if (entity.getId() != null && !"".equals(entity.getId())) {
            return entity;
        }
        entity.setId(CommonUtil.getShortSnowFlakeId());
        entity.setCreator(parameter.getString("userId") != null && !parameter.getString("userId").equals("") ? parameter.getString("userId") : "-1");
        entity.setLastUpdateBy(parameter.getString("userId") != null && !parameter.getString("userId").equals("") ? parameter.getString("userId") : "-1");
        entity.setCreateTime(CommonUtil.formatDate(""));
        entity.setLastUpdateTime(new Date());
        entity.setVersion(1L);
        entity.setIsDelete(0);
        return entity;
    }
}
