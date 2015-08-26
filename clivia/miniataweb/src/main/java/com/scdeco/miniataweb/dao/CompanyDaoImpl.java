package com.scdeco.miniataweb.dao;
import org.springframework.stereotype.Repository;

import com.scdeco.miniataweb.model.Company;

@Repository ("companyDao")
public class CompanyDaoImpl extends GenericDaoImpl<Company, Integer> implements CompanyDao {

}