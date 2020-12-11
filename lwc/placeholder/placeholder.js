import { LightningElement, api } from 'lwc';

/** Static Resources. */
import PG_ASSETS_URL from '@salesforce/resourceUrl/pg_assets';

export default class Placeholder extends LightningElement {
    @api message;

    /** Url for no result logo. */
    logoUrl = `${PG_ASSETS_URL}/NoResult.png`;
}